class Url < ApplicationRecord
    before_create :generate_short_code
  
    validates :original_url, presence: true # Adiciona validação para garantir que a URL original não esteja vazia
  
    private
  
    def generate_short_code
      # Gera um código aleatório de 6 caracteres alfanuméricos
      # e só atribui a self.short_code se ele ainda não tiver um valor (nil ou vazio)
      self.short_code = SecureRandom.alphanumeric(6) if self.short_code.blank? 
  
      # Opcional: adicionar um loop para garantir a unicidade (mais avançado, bom para depois)
      # while Url.exists?(short_code: self.short_code)
      #   self.short_code = SecureRandom.alphanumeric(6)
      # end
    end
  end