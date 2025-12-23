FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV RUBY_VERSION=3.1.2
ENV BUNDLER_VERSION=2.3.17
ENV NODE_VERSION=18

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    procps \
    libpq-dev \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    ca-certificates \
    gnupg \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn@1.22.19

# Install rbenv and Ruby
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash -s stable

# Set PATH to include rbenv
ENV PATH="/root/.rbenv/shims:/root/.rbenv/bin:$PATH"
ENV RBENV_ROOT="/root/.rbenv"

# Initialize rbenv in bash profile
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.profile && \
    echo 'eval "$(rbenv init -)"' >> /root/.profile

# Install Ruby using rbenv
RUN /bin/bash -l -c "rbenv install ${RUBY_VERSION} && \
    rbenv global ${RUBY_VERSION} && \
    rbenv rehash && \
    gem install bundler:${BUNDLER_VERSION} && \
    rbenv rehash"

# Set working directory
WORKDIR /app

# Copy entire project (including admin directory) BEFORE bundle install
COPY . /app

# Set ownership
RUN chown -R root:root /app

# Install Ruby dependencies
# Use bash -l to ensure rbenv is properly initialized
RUN /bin/bash -l -c "bundle install"

# Precompile bootsnap
RUN /bin/bash -l -c "bundle exec bootsnap precompile --gemfile"

# Install Node.js dependencies
RUN yarn install

# Build assets (includes admin assets)
RUN yarn build

# Precompile Rails assets
RUN /bin/bash -l -c "RAILS_ENV=production SECRET_KEY_BASE=dummy bundle exec rails assets:precompile"

# Expose port (Railway will set PORT environment variable)
EXPOSE ${PORT:-3000}

# Start command (rbenv will be available via PATH in CMD)
CMD /bin/bash -l -c "bundle exec puma -C config/puma.rb"

