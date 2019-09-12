Rails.application.routes.draw do
  get "/1", to: "prototypes#topic_and_question_listing"
  get "/2", to: "prototypes#average_water_pump_depth"
  get "/3", to: "prototypes#mark_workshop_as_finished"
end
