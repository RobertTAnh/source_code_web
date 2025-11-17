# README

Waker

# Tech stack

+ Ruby: 3.1.2
+ Rails: 7
+ Database: postgres
+ Bootstrap: 5
+ Jquery: 3.6
+ Test: rspec

# Setup project

1. Install prequisitions

+ ruby 3.1.2
+ yarn

2. Clone project

3. Run `bundle install`

4. Run `yarn install`

5. Setup environment

Copy `.env.development` to `.env.development.local` and add values

6. Migrate data

```bash
bundle exec rake db:migrate
bundle exec rake db:seed
```

7. Run `foreman start -f Procfile.dev`

If work on admin, should run:

```
foreman start -f Procfile.admin
```

# Git workflow

## Workflow

1. Checkout from dev to new branch

2. Develop

3. Create merge request to dev

4. Wait for review and approval

## Naming convention

### Branch name

+ For a feature: feature/<feature_name>
+ For frontend: fe/<component>
+ For fixing bug: bug/fix_something

### Commit message

**Rules:**

1. Always start with a verb: create / add / update / remove
2. Always use downcase
3. Include jira ticket [WAK-10]

**Examples:**

+ [WAK-10] add featured products section to home page
+ [WAK-10] add upload image feature
+ [Core] add rubocop
+ [Bug] fix product loading error
