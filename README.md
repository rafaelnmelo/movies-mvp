## Arquitetura do Projeto

Arquitetura utilizada: MVP

Foi utilizada esta arquitetura pois além de minha maior familiaridade com a mesma, ele proporciona 
uma melhor separação das camadas do projeto. Tendo a Model como a camada de dados, a View 
com todos os elementos gr‡ficos e finalmente o Presenter, que tem por sua miss‹o integrar os 
dados da Model de uma forma apresent‡vel para cada View 

## Bibliotecas Utilizadas

Alamofire: utilizada para facilitar o gerenciamento de requisições da API do TheMovieDB.

Kingfisher: utilizado para efetuar o download e utilização das imagens necess‡rias

## Funcionalidades

Tela de Home com duas abas:
Filmes: Um grid exibindo os filmes melhores classificados.
Favoritos: Uma listagem dos filmes marcados como favorito. 

Loading no carregamento da listagem de filmes;

Tela de tratamento de erros (falta de internet e erro na api) na tela de Filmes;

Tela de detalhe do filme com informações dos gêneros;

Favoritar um filme na tela de detalhe com armazenamento local. 

Açao de remover o filme da lista de Favoritos com swipe.

Adequação do tema do aplicativo pra ter uma sensação mais agradável ao 
usuário sendo mais parecida com uma sala de cinema
