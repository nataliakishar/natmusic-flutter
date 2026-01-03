# 🎵 NatMusic

NatMusic é um aplicativo mobile desenvolvido em **Flutter**, focado em gerenciamento e reprodução de músicas de forma simples, elegante e intuitiva.

O projeto foi criado como estudo prático de Flutter, abordando estrutura de projeto, UI, gerenciamento de estado básico e persistência de dados.

---

## 📱 Preview



### Tela Principal
<p align="center">
  <img src="[assets/images/app_screen.png" width="300](https://github.com/user-attachments/assets/a953773c-e00a-4da0-9550-bcfedb52f5fd)"/>
  
  
</p>

<p >

![WhatsApp Image 2026-01-03 at 18 20 49](https://github.com/user-attachments/assets/db5cb2e9-7d7b-47a3-96ab-1fe3daaa297e)
  
</p>

### Ícone do App
<p align="center">

![WhatsApp Image 2026-01-03 at 18 25 34](https://github.com/user-attachments/assets/8c226f2b-1239-45d8-b08e-247251203b32)


  
</p>








- ▶️ Reproduzir músicas
- ➕ Adicionar músicas à lista
- ✏️ Editar músicas
- 🗑️ Remover músicas
- 🎨 Interface limpa e moderna
- 📱 Layout responsivo

---

## 🛠️ Tecnologias Utilizadas

- **Flutter**
- **Dart**
- Material Design

---

## 🚀 Como executar o projeto

### Pré-requisitos
- Flutter instalado
- Android Studio ou VS Code
- Emulador Android ou dispositivo físico

### Passos

```bash
# Clone o repositório
git clone https://github.com/nataliakishar/natmusic-flutter.git

# Entre na pasta do projeto
cd natmusic-flutter

# Instale as dependências
flutter pub get

lib/
 ├── main.dart
 ├── models/
 ├── screens/
 ├── widgets/
assets/
 └── images/

---

## 🖼️ Agora o passo **muito importante**: onde colocar as imagens

No seu projeto, faça assim:


👉 Use exatamente esses nomes para não dar erro no README.

Depois, **confira se o `pubspec.yaml` já tem assets habilitados** (provavelmente sim):

```yaml
flutter:
  assets:
    - assets/images/
git add README.md assets/images
git commit -m "Add professional README with app preview"


# Execute o app
flutter run
