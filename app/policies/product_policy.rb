class ProductPolicy < BasePolicy
  def edit
    record.owner?
  end
  
  def update
    record.owner?
  end
  
  def delete
    record.owner?
  end  
end