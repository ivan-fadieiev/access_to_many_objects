class Service
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :id,
                :add_first_title,  :add_first_body,  :add_first_text,
                :add_second_title, :add_second_body, :add_second_text,
                :add_third_title,  :add_third_body,  :add_third_text,
                :add_fourth_title, :add_fourth_body, :add_fourth_text

  validates_presence_of :name
  validates_format_of :email, with: /@/
  validates_presence_of :add_first_title, :add_first_body,  :add_first_text, allow_blank: true

  class << self
    def find(id)
      user ||= User.eager_load(assoc_to_sym).find(id)
      @user_info = Service.new

      %w(name email id).each do |attr|
        eval("@user_info.#{attr}    = user.#{attr}")
      end

      assoc_to_s.each do |type|
        assoc_for_find(@user_info, user, type)
      end

      @user_info
    end

    def assoc_for_find(user_info, user, type)
      %w(title body text).each do |attr|
        eval("user_info.#{type}_#{attr}  = user.#{type}&.#{attr}")
      end
    end

    private

    def assoc_to_s
      %w(add_first add_second add_third add_fourth)
    end

    def assoc_to_sym
      %i(add_first add_second add_third add_fourth)
    end
  end


  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save!
    user = User.new(name: name, email: email)

    assoc_to_s.each do |type|
      save_assoc!(type, user)
    end

    user.save?
  end

  def update!(params={})
    user = User.eager_load(assoc_to_sym).find(id)

    user.update(name: params[:name], email: params[:email])

    assoc_to_s.each do |type|
      update_assoc!(type, user, params)
    end
  end

  private

  def assoc_to_s
    self.class.send("assoc_to_s")
  end

  def assoc_to_sym
    self.class.send("assoc_to_sym")
  end

  def save_assoc!(type, user)
    eval("@assoc = user.build_#{type}(title: #{type}_title,
                             body: #{type}_body,
                             text: #{type}_text)")
    @assoc.check!
  end

  def update_assoc!(type, user, params)
    if user.send(type)
      eval("user.#{type}.update_attributes(title: params[:#{type}_title],
                                           body:  params[:#{type}_body],
                                           text:  params[:#{type}_text])")
    else
      save_assoc!(type, user)
    end
  end
end