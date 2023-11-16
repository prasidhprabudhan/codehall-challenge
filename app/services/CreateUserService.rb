class CreateUserService
    attr_reader :errors, :college, :exam, :options

    def initialize(options = {})
        @options = options
        @errors = []
    end

    def process
        load_college
        load_exam 
        check_if_exam_belong_to_college if errors.empty?
        return if errors.present?

        find_or_create_user
    end

    private

        def load_record(model, id, error_message)
            record = model.find_by_id(id)
            unless record
              errors << error_message
            end
            record
          end
          
          def load_college
            @college = load_record(College, options[:college_id], I18n.t('errors.not_found', entity: "College"))
          end
          
          def load_exam
            @exam = load_record(Exam, options[:exam_id], I18n.t('errors.not_found', entity: "Exam"))
          end
          

        def check_if_exam_belong_to_college
            if exam.college.id != college.id
                errors << I18n.t('errors.not_belong', entity1: "Exam", entity2: "college")
            end
        end

        def find_or_create_user
            user = User.find_or_initialize_by(options)
            unless user.save
                errors << user.errors.full_messages.to_sentence
            end
            user
        end
end


