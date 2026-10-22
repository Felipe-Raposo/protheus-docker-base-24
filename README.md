# Protheus Docker Base 24.x.y.z (Onça Preta)

Imagem Docker base para execução do **TOTVS Protheus 12** (AppServer) em ambiente containerizado.

## Descrição

Este projeto monta a imagem `feliperaposo/protheus-docker-base:24`, usada pelo License Server e pelo Protheus 12.1.2510. Ela estende [protheus-docker-baselight:24](https://github.com/Felipe-Raposo/protheus-docker-baselight-24) com `appserver.ini`, SmartClient WebApp e Web Agent.

Se estiver buscando um ambiente completo com Protheus + License + dbAccess + Postgres, acesse esse [projeto](https://github.com/Felipe-Raposo/protheus-docker-compose).

### Características

- **Base:** `feliperaposo/protheus-docker-baselight:24` (Oracle Linux 9 Slim + AppServer 24.3.1.9)
- **Protheus:** AppServer (porta TCP 1234)
- **DBAPI:** `dbapi.so` baixado de `http://dbaccess:7891/dbapi.so` para `/protheus12/bin/appserver/` na inicialização, quando o `appserver.ini` tem `[DBAccess]` (`DBAPI_URL` substitui a URL)
- **Printer:** `printer` em `/protheus12/bin/appserver/`
- **SmartClient WebApp:** `webapp.so` em `/protheus12/bin/appserver/`
- **Web Agent:** 1.1.2 (instaladores deb/rpm/dmg/exe em `/protheus12/bin/webagent/`)
- **REST API:** Habilitada na porta 8080 (`/rest`)
- **APP Monitor:** Habilitada na porta 32033 (`/app-monitor`)
- **Configuração dinâmica:** Banco de dados definido via variável de ambiente `APPSERVER_DATABASE`

## Pré-requisitos

- Docker (com BuildKit habilitado para build)
- Host de build `linux/amd64` (`make build` passa `--platform=linux/amd64`)
- Imagem `feliperaposo/protheus-docker-baselight:24` disponível localmente ou no registry

## Build

```bash
# Build local das tags de versão
make build
```

## Publicação da imagem

```bash
# Build e push das tags de versão
make release

# Incluir também a tag latest
make release_latest
```

Gera as tags:

- `feliperaposo/protheus-docker-base:24`
- `feliperaposo/protheus-docker-base:24.3.1.9`
- `feliperaposo/protheus-docker-base:latest`

## Estrutura interna (referência)

- **Entrypoint:** `/protheus.sh`
- **APO:** `/protheus12/apo/`
- **AppServer:** Binários do baselight em `/protheus12/bin/appserver/`; overlay desta imagem: `appserver.ini`, `printer`, `webapp.so`. O `dbapi.so` vem do dbAccess na inicialização.
- **Web Agent:** `/protheus12/bin/webagent/`
- **Configuração:** `appserver.ini` (parâmetro `{{APPSERVER_DATABASE}}` substituído em runtime)
- **Protheus Data:** `/protheus12/protheus_data/`
- **SystemLoad:** Descompactação automática de `systemload.tar.xz` em `/protheus12/protheus_data/systemload` na primeira inicialização

## Licença

Este projeto está sob a [GNU General Public License v3.0](LICENSE).

## Mantenedor

Felipe Raposo — [feliperaposo@gmail.com](mailto:feliperaposo@gmail.com)
