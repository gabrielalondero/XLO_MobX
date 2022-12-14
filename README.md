# XLO MobX
 - App para cadastrar anúncios.
 - Login dos usuários é feito via email cadastrado no próprio app.
 - O banco de dados utilizado foi o ParseServer. 
 - Backend feito no [Back4App](https://www.back4app.com/).
 - A gerência de estado foi feita com MobX.
 - Detalhes:
    - Poderá ver os anúncios:
        - filtrando por Categoria, preço máximo e mínimo, perfil profissional ou particular;
        - Ordenado por Preço(do menor ao maior) ou Data de publicação(da mais recente para a mais antiga);
        - Poderá ver mesmo não estando logado;
        
    - Ao estar logado, pode-se:
        - Favoritar/Desfavoritar os anúncios;
        - Ver lista de anúncios favoritados;
        - Cadastrar, e editar ou excluir anúncios que sejam seus;
        - Ver os anúncios ativos, pendentes e vendidos;
        - Mudar o status do pedido para vendido.
        - Editar dados do perfil.
    

APIs utilizadas:

 - [ViaCEP](https://viacep.com.br/) para os ceps
 - [IBGE](https://servicodados.ibge.gov.br/api/docs/localidades) para a localidade.

Puglins:

 - `parse_server_sdk_flutter`
 - `mobx`
 - `build_runner`
 - `mobx_codegen` 
 - `flutter_mobx`
 - `get_it` - Para facilitar o acesso a objetos
 - `brasil_fields`
 - `image_picker` - Para selecionar imagens na galeria ou tirar fotos com a câmera
 - `image_cropper` - Para cortar as imagens
 - `dio`
 - `shared_preferences`
 - `path`
 - `cached_network_image` - Para guardar as imagens em cache
 - `intl`
 - `flutter_localizations` - Pacote para simplificar a tradução no aplicativo.
 - `readmore` - Para adicionar a opção de 'ler mais' em textos grandes
 - `url_launcher` - Para abrir o app de telefone.
 - `toggle_switch` - para criar botões com alternância, mantendo o estado da seleção (está na edit_account_screen)
 - `internet_connection_checker` - Para verificar se há conexão ativa com a internet



