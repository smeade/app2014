module ContactsHelper

  def display_name(contact)
    [contact.first_name, contact.last_name].join(" ") + " (" + contact.client.name + ")"
  end

  def full_name(contact)
    [contact.first_name, contact.last_name].join(" ")
  end

  def full_name_and_email(contact)
    fnae = [contact.first_name, contact.last_name].join(" ")
    fnae += " (#{contact.email})" unless contact.email.blank?
    fnae
  end

end
