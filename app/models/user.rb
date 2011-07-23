class User < ActiveRecord::Base

  validates_format_of :username,
    :with => /^[-_a-z0-9]+$/,
    :message => "Username must be letters, numbers, underscore and dash"

  validates_uniqueness_of :username

  validates_format_of :email,
    :with => /^[^@]+@[^@]+$/,
    :message => "Email address must be valid"

  validates_uniqueness_of :email

  validates_presence_of :password_salt, :password_hash

  def password= password_text
    self.password_salt = random_letters 16
    self.password_hash = gen_hash password_text
  end

  def password
    nil
  end

  def check_password guess
    return password_hash == gen_hash(guess)
  end

private

  def gen_hash text
    return Digest::SHA1.hexdigest "#{password_salt}:#{text}"
  end

  def random_letters len
    numbers = ("a".."z").to_a
    newrand = ""
    1.upto(len) { |i| newrand << numbers[rand(numbers.size - 1)] }
    return newrand
  end

end
