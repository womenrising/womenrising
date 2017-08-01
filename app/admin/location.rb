ActiveAdmin.register Location do
  config.comments = false

  controller do
    def permitted_params
      params.permit!
    end
  end
end
