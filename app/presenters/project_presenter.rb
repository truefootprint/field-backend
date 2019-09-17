class ProjectPresenter < ApplicationPresenter
  def present
    { name: record.name }
  end

  class WithProjectActivities < self
    def present
      presented = presenter_variant.present(record.project_activities)
      super.merge(project_activities: presented)
    end

    def presenter_variant
      ProjectActivityPresenter
    end

    class WithProjectQuestions < self
      def presenter_variant
        ProjectActivityPresenter::WithProjectQuestions
      end

      class ByTopic < self
        def presenter_variant
          ProjectActivityPresenter::WithProjectQuestions::ByTopic
        end
      end
    end
  end
end
