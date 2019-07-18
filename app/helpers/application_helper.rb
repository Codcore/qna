module ApplicationHelper
  BOOTSTRAP_CLASSES_FOR_FLASH = { :success => 'alert-success',
                                  :error => 'alert-danger',
                                  :alert => 'alert-warning',
                                  :notice => 'alert-info' }.freeze

  def bootstrap_class_for_flash(flash_type)
    BOOTSTRAP_CLASSES_FOR_FLASH[flash_type]
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
