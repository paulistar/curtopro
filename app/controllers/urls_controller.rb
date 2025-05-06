class UrlsController < ApplicationController
  # Define o @url para as ações show, edit, update e destroy
  before_action :set_url, only: %i[ show edit update destroy ]

  # --- NOSSA NOVA AÇÃO DE REDIRECIONAMENTO ---
  # GET /:short_code
  def redirect
    # Busca a URL no banco de dados usando o short_code vindo da rota (params[:short_code])
    url = Url.find_by(short_code: params[:short_code])

    # Verifica se a URL foi encontrada
    if url
      # Incrementa o contador de cliques. O '!' faz com que salve imediatamente no banco.
      url.increment!(:clicks)
      # Redireciona o navegador para a URL original armazenada
      # allow_other_host: true é necessário para redirecionar para domínios externos
      # status: :moved_permanently envia um código HTTP 301 (bom para SEO)
      redirect_to url.original_url, allow_other_host: true, status: :moved_permanently
    else
      # Se não encontrou nenhuma URL com esse short_code, retorna uma página simples com erro 404
      render plain: 'URL não encontrada / URL not found', status: :not_found
    end
  end
  # --- FIM DA NOVA AÇÃO ---


  # GET /urls ou /urls.json
  # Lista todas as URLs
  def index
    @urls = Url.all
  end

  # GET /urls/1 ou /urls/1.json
  # Mostra os detalhes de uma URL específica (baseado no :id)
  def show
  end

  # GET /urls/new
  # Prepara o formulário para criar uma nova URL
  def new
    @url = Url.new
  end

  # GET /urls/1/edit
  # Prepara o formulário para editar uma URL existente (baseado no :id)
  def edit
  end

  # POST /urls ou /urls.json
  # Recebe os dados do formulário (new) e tenta criar a URL no banco
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        # Se salvou com sucesso, redireciona para a página de detalhes da URL criada
        format.html { redirect_to @url, notice: "Url criada com sucesso." } # Alterado notice para português
        format.json { render :show, status: :created, location: @url }
      else
        # Se houve erro (ex: validação falhou), mostra o formulário de novo com os erros
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /urls/1 ou /urls/1.json
  # Recebe os dados do formulário (edit) e tenta atualizar a URL no banco
  def update
    respond_to do |format|
      if @url.update(url_params)
        # Se atualizou com sucesso, redireciona para a página de detalhes da URL atualizada
        format.html { redirect_to @url, notice: "Url atualizada com sucesso." } # Alterado notice para português
        format.json { render :show, status: :ok, location: @url }
      else
        # Se houve erro, mostra o formulário de edição com os erros
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /urls/1 ou /urls/1.json
  # Deleta uma URL do banco de dados (baseado no :id)
  def destroy
    @url.destroy!

    respond_to do |format|
      # Após deletar, redireciona para a lista de URLs
      format.html { redirect_to urls_path, status: :see_other, notice: "Url excluída com sucesso." } # Alterado notice para português
      format.json { head :no_content }
    end
  end

  # Métodos privados só podem ser chamados dentro deste controller
  private
    # Método usado pelo before_action para buscar a URL pelo :id da rota
    # nas ações show, edit, update, destroy
    def set_url
      @url = Url.find(params[:id]) # Alterado de params.expect(:id) para params[:id] para compatibilidade
    end

    # Método de segurança ("Strong Parameters")
    # Define quais parâmetros são permitidos ao criar ou atualizar uma URL
    # Isso previne que usuários maliciosos injetem dados indesejados
    def url_params
      # Exige que os parâmetros tenham a chave :url e permite apenas :original_url, :short_code, :clicks
      # Importante: Mesmo que clicks e short_code sejam gerados/atualizados internamente,
      # pode ser útil permitir via params em alguns casos (ou você pode removê-los daqui se não quiser permitir)
      params.require(:url).permit(:original_url, :short_code, :clicks) # Alterado de params.expect para params.require/.permit
    end
end