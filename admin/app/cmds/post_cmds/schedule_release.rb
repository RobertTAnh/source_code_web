module PostCmds
  class ScheduleRelease
    prepend BaseCmd

    def call
      validate
      release unless failure?
      output
    end

    private

    attr_reader :context

    def validate
    end

    def release
      schedule_posts.update_all(status: "published")
    end

    def output
    end

    def schedule_posts
      Post.unpublished.where("release_date <= ?", Time.now)
    end
  end
end

