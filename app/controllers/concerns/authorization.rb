module Authorization
  extend ActiveSupport::Concern

  included do
    class NotAuthorizedError < StandardError; end

    rescue_from NotAuthorizedError do
      redirect_to products_path, alert: t('common.not_authorized')
    end

    private

    def authorize! record = nil
      # La primera parte se crea la clase de manera dinamica (nombre del controlador, y lo ponemos en singular) (classify, lo pone en formato de clase CamelCase)
      # y (constantize, lo convierte a la clase). El '.new' va ya que se esta llamando a la clase del Policy. Y por ultimo el "send(action_name)" nos da la accion que se esta llamando.
      is_allowed = "#{controller_name.singularize}Policy".classify.constantize.new(record).send(action_name)
      raise NotAuthorizedError unless is_allowed
    end
  end
end