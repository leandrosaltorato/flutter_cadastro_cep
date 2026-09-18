# Cadastro de Pessoas, consumo de APIs Externas

**Desafio escolhido:** Desafio 01 - Aplicativo de cadastro de pessoas com
integração à API pública [ViaCEP](https://viacep.com.br/) para
preenchimento automático de endereço.

---

## Funcionalidades implementadas

| Requisito | Descrição | Status |
|---|---|:---:|
| **RF001** | Splash Screen com logo e animações explícitas de **entrada** (fade-in + escala com efeito bounce + leve rotação) e de **saída** (fade-out + redução de escala) antes de navegar para a Home | OK |
| **RF002** | Tela Home com cabeçalho (AppBar), menu lateral tipo sanduíche (Drawer), lista das pessoas cadastradas e botão flutuante `+` para adicionar novo cadastro | OK |
| **RF003** | Tela de Cadastro com os campos **CEP**, **Número** e **Complemento** editáveis; ao preencher o CEP (8 dígitos) os campos **Rua**, **Bairro**, **Cidade** e **Estado** são preenchidos automaticamente via API ViaCEP; botão para salvar o cadastro localmente no celular | OK |

### Funcionalidades extras (não obrigatórias)
- Campo **Nome** no formulário, necessário para identificar a pessoa cadastrada.
- Remoção de um cadastro da lista (ícone de lixeira em cada item).
- Validação de formulário e tratamento de erros: CEP inexistente ou falha de
  rede exibe aviso (SnackBar) e impede salvar sem endereço válido.
- Máscara no campo CEP (aceita apenas números, máximo 8 dígitos).

---

## API utilizada

**ViaCEP** — `GET https://viacep.com.br/ws/{cep}/json/`
Retorna `logradouro`, `bairro`, `localidade` (cidade) e `uf` (estado) a partir
de um CEP válido, ou `{"erro": true}` quando o CEP não existe.

---

## Tecnologias e pacotes

- **Flutter / Dart**
- [`http`](https://pub.dev/packages/http) — requisições REST (GET) à API ViaCEP
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) — persistência local dos cadastros no dispositivo

---

## Arquitetura do projeto

```
assets/
 └── images/
     └── logo.png                
lib/
 ├── main.dart                    
 ├── models/
 │   └── pessoa.dart               
 ├── services/
 │   ├── viacep_service.dart       
 │   └── storage_service.dart      
 ├── screens/
 │   ├── splash_screen.dart       
 │   ├── home_screen.dart          
 │   └── cadastro_screen.dart      
 └── widgets/
     └── app_drawer.dart           
```

---

## Como executar o projeto

1. Instale o [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal *stable*).
2. Clone este repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd cadastro_pessoas_app
   ```
3. Baixe as dependências:
   ```bash
   flutter pub get
   ```
4. Conecte um dispositivo/emulador e rode:
   ```bash
   flutter run
   ```

## Prints das telas

| Splash Screen | Home | Cadastro |
|:---:|:---:|:---:|
| _(inserir print aqui)_ | _(inserir print aqui)_ | _(inserir print aqui)_ |

---

## Download do APK

Link para download: _(inserir aqui o link do APK gerado — Google Drive, GitHub Releases, etc.)_

