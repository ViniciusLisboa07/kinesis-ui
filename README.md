# KinesisUi

![](https://github.com/ViniciusLisboa07/kinesis-ui/blob/073d14ec644be2e61802ea2e8c37ca262b10f7a8/Kinesis%20UI.png)

Uma gem Ruby on Rails para criação rápida de componentes de UI modernos com Tailwind CSS e Stimulus.

KinesisUi
 fornece um conjunto de componentes pré-construídos e personalizáveis para acelerar o desenvolvimento de interfaces de usuário em aplicações Rails.

## Características

- 🎨 **Componentes Modernos**: Modal, botões e mais componentes em desenvolvimento
- ⚡ **Stimulus Integration**: Controladores JavaScript prontos para uso
- 🎯 **Tailwind CSS**: Estilização moderna e responsiva
- 🔧 **Configurável**: Personalize classes e comportamentos facilmente
- 📦 **Rails Engine**: Integração perfeita com aplicações Rails existentes

## Instalação

Adicione esta linha ao Gemfile da sua aplicação:

```ruby
gem "kinesis_ui"
```

Execute:

```bash
$ bundle install
```

Em seguida, execute o gerador de instalação:

```bash
$ rails generate kinesis_ui:install
```

Este comando irá:
- Criar um arquivo de inicialização em `config/initializers/kinesis_ui.rb`
- Adicionar helpers ao `ApplicationHelper`
- Configurar controladores Stimulus
- Configurar assets CSS

## Uso

### Modal

#### Usando o helper:

```erb
<!-- Modal básico -->
<%= kinesis_modal(
  title: "Meu Modal",
  body: "Este é o conteúdo do modal",
  trigger_text: "Abrir Modal"
) %>

<!-- Modal com confirmação -->
<%= kinesis_modal(
  title: "Confirmar Ação",
  body: "Você tem certeza que deseja continuar?",
  trigger_text: "Deletar Item",
  confirm_action: true,
  confirm_text: "Sim, deletar",
  close_text: "Cancelar"
) %>

<!-- Modal com conteúdo personalizado -->
<%= kinesis_modal(title: "Formulário", trigger_text: "Abrir Formulário") do %>
  <%= form_with model: @user do |f| %>
    <div class="mb-4">
      <%= f.label :name, class: "block text-sm font-medium mb-2" %>
      <%= f.text_field :name, class: "w-full border rounded px-3 py-2" %>
    </div>
    <div class="mb-4">
      <%= f.label :email, class: "block text-sm font-medium mb-2" %>
      <%= f.email_field :email, class: "w-full border rounded px-3 py-2" %>
    </div>
    <%= f.submit "Salvar", class: "bg-blue-600 text-white px-4 py-2 rounded" %>
  <% end %>
<% end %>
```

#### Usando render direto:

```erb
<%= render "kinesis_ui/components/modal",
    title: "Meu Modal",
    body: "Conteúdo do modal",
    trigger_text: "Abrir"
%>
```

### Botões

```erb
<!-- Botões com diferentes variantes -->
<%= kinesis_button "Primário", variant: :primary %>
<%= kinesis_button "Secundário", variant: :secondary %>
<%= kinesis_button "Perigoso", variant: :danger %>
<%= kinesis_button "Sucesso", variant: :success %>

<!-- Diferentes tamanhos -->
<%= kinesis_button "Pequeno", size: :small %>
<%= kinesis_button "Médio", size: :medium %>
<%= kinesis_button "Grande", size: :large %>

<!-- Com atributos personalizados -->
<%= kinesis_button "Clique aqui", 
    variant: :primary, 
    onclick: "alert('Clicado!')",
    class: "my-custom-class"
%>
```

### Eventos Stimulus

Os componentes KinesisUi disparam eventos personalizados que você pode escutar:

```javascript
// Modal events
document.addEventListener("modal:opened", (event) => {
  console.log("Modal foi aberto");
});

document.addEventListener("modal:closed", (event) => {
  console.log("Modal foi fechado");
});

document.addEventListener("modal:confirmed", (event) => {
  console.log("Usuário confirmou a ação");
  // Aqui você pode executar sua lógica de confirmação
});
```

## Configuração

Personalize o KinesisUi editando o arquivo `config/initializers/kinesis_ui.rb`:

```ruby
KinesisUi.configure do |config|
  # Personalizar classes CSS do modal
  config.default_classes[:modal][:backdrop] = "fixed inset-0 bg-black/50 flex items-center justify-center z-50"
  config.default_classes[:modal][:container] = "bg-white p-8 rounded-xl shadow-2xl max-w-lg w-full mx-4"
  
  # Configurar comportamento padrão dos componentes
  config.components[:modal][:close_on_backdrop] = true
  config.components[:modal][:close_on_escape] = true
  config.components[:modal][:animation] = true
  
  # Personalizar classes de botões
  config.default_classes[:button][:primary] = "bg-indigo-600 text-white hover:bg-indigo-700"
end
```

## Componentes Disponíveis

### Modal ✅
- Backdrop clicável para fechar
- Fechamento com tecla ESC
- Suporte a confirmação de ações
- Conteúdo personalizável
- Eventos Stimulus

### Button ✅
- Múltiplas variantes (primary, secondary, danger, success)
- Diferentes tamanhos
- Classes personalizáveis

### Em Desenvolvimento 🚧
- Alert/Notification
- Dropdown
- Tooltip
- Card
- Form Components
- Navigation

## Dependências

- Rails >= 7.2.2.1
- TailwindCSS Rails
- Stimulus (incluído no Rails 7+)

## Desenvolvimento

Para contribuir com a gem:

1. Clone o repositório
2. Execute `bundle install`
3. Execute os testes com `rake test`
4. Faça suas alterações
5. Adicione testes para novas funcionalidades
6. Envie um Pull Request

### Estrutura do Projeto

```
kinesis-ui/
├── app/
│   ├── assets/stylesheets/kinesis_ui/    # CSS da gem
│   ├── helpers/kinesis_ui/               # Helpers Rails
│   ├── javascripts/controllers/          # Controladores Stimulus
│   └── views/kinesis_ui/components/      # Templates dos componentes
├── lib/
│   ├── generators/kinesis_ui/            # Geradores Rails
│   ├── kinesis_ui/
│   │   ├── configuration.rb             # Sistema de configuração
│   │   ├── engine.rb                    # Rails Engine
│   │   └── version.rb                   # Versão da gem
│   └── kinesis_ui.rb                    # Arquivo principal
└── test/                                # Testes
```

### Rodando Testes

```bash
# Executar todos os testes
rake test

# Executar teste específico
ruby test/kinesis_ui_test.rb

# Executar testes de integração
ruby test/integration/navigation_test.rb
```

### Testando Localmente

Para testar a gem em uma aplicação Rails:

1. No `Gemfile` da sua app de teste:
```ruby
gem 'kinesis_ui', path: '/caminho/para/kinesis-ui'
```

2. Execute:
```bash
bundle install
rails generate kinesis_ui:install
```

## Troubleshooting

### Modal não aparece
- Verifique se o Tailwind CSS está incluído
- Confirme que os controladores Stimulus foram registrados
- Verifique se não há conflitos de z-index

### Estilos não aplicados
- Confirme que `kinesis_ui/application.css` está sendo importado
- Para Tailwind, verifique se `application.tailwind.css` inclui os estilos da KinesisUi

### JavaScript não funciona
- Verifique se Stimulus está configurado corretamente
- Confirme que os controladores KinesisUi foram registrados
- Verifique o console do navegador por erros

## Contribuindo

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas alterações (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Roadmap

- [ ] Componente Alert/Notification
- [ ] Componente Dropdown
- [ ] Componente Tooltip
- [ ] Componente Card
- [ ] Form Builders personalizados
- [ ] Temas predefinidos
- [ ] Suporte a outros frameworks CSS
- [ ] Documentação interativa

## Licença

Esta gem está disponível como open source sob os termos da [MIT License](https://opensource.org/licenses/MIT).

## Créditos

Desenvolvido por [ViniciusLisboa07](https://github.com/ViniciusLisboa07)

## Links

- [Código Fonte](https://github.com/ViniciusLisboa07/kinesis_ui)
- [Issues](https://github.com/ViniciusLisboa07/kinesis_ui/issues)
- [Pull Requests](https://github.com/ViniciusLisboa07/kinesis_ui/pulls)
