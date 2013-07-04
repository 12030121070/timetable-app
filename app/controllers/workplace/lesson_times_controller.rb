class Workplace::LessonTimesController < Workplace::WorkplaceController
  inherit_resources

  actions :all

  belongs_to :organization, :polymorphic => true
end
