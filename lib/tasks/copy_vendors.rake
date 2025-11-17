require 'open3'

namespace :assets do
  desc 'copy vendors to assets'
  task :copy_vendors do
    logger.info 'Copying vendors to assets'

    copy_fontawesome
    copy_ckeditor4
    download_ckeditor_plugins
  end

  def run_system_command command
    begin
      logger.info command
      stdout, stderr, status = Open3.capture3(command)
      if status.exitstatus != 0
        if stderr.empty?
          raise "Command failed with exit status: #{status.exitstatus}"
        else
          raise "Command failed with error: #{stderr}"
        end
      else
        logger.info stdout
      end
    rescue => e
      raise "Command failed: #{e}"
    end
  end

  def copy_fontawesome
    copy_folder 'node_modules/@fortawesome/fontawesome-free/webfonts', 'fontawesome-free/'
  end

  def copy_ckeditor4
    fcopy 'node_modules/ckeditor4/config.js', 'ckeditor4/'
    fcopy 'node_modules/ckeditor4/contents.css', 'ckeditor4/'
    fcopy 'node_modules/ckeditor4/styles.js', 'ckeditor4/'
    copy_folder 'node_modules/ckeditor4/lang', 'ckeditor4/'
    copy_folder 'node_modules/ckeditor4/plugins', 'ckeditor4/'
    copy_folder 'node_modules/ckeditor4/skins', 'ckeditor4/'
  end

  def download_ckeditor_plugins
    logger.info "Downloading ckeditor plugin: imageuploader"

    url = 'https://download.ckeditor.com/imageuploader/releases/imageuploader_4.1.8.zip'

    Dir.mktmpdir do |dir|
      downloaded_file = Pathname.new(dir).join('imageuploader_4.1.8.zip')
      run_system_command("curl #{url} -o #{downloaded_file}")
      run_system_command("rm -rf #{target_path('ckeditor4/plugins/imageuploader')}")
      run_system_command("unzip -o #{downloaded_file} -d #{target_path('ckeditor4/plugins/')}")
    end

    logger.info "Downloading ckeditor plugin: html5video"

    url = 'https://waker.fagotech.vn/assets/libs/html5video_1.2.zip'

    Dir.mktmpdir do |dir|
      downloaded_file = Pathname.new(dir).join('html5video_1.2.zip')
      run_system_command("curl #{url} -o #{downloaded_file}")
      run_system_command("rm -rf #{target_path('ckeditor4/plugins/html5video')}")
      run_system_command("unzip -o #{downloaded_file} -d #{target_path('ckeditor4/plugins/')}")
      run_system_command("cp -r #{target_path('ckeditor4/plugins/ckeditor-html5-video-master/html5video')} #{target_path('ckeditor4/plugins/')}")
      run_system_command("rm -rf #{target_path('ckeditor4/plugins/ckeditor-html5-video-master')}")
    end
  end

  def fcopy(source, target)
    logger.info "Copying #{source}"

    run_system_command("cp -f #{source_path(source)} #{target_path(target)}")
  end

  def copy_folder(source, target)
    logger.info "Copying #{source}"

    run_system_command("cp -rf #{source_path(source)} #{target_path(target)}")
  end

  def source_path(source)
    Rails.root.join(source)
  end

  def target_path(target)
    Rails.public_path.join('assets', target).tap do |path|
      run_system_command("mkdir -p #{path}")
    end
  end

  def logger
    @logger ||= ActiveSupport::Logger.new(STDOUT)
  end
end

Rake::Task['assets:precompile'].enhance do
  Rake::Task['assets:copy_vendors'].invoke
end
