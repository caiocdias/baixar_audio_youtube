# YouTube Audio Downloader

Script simples em Python para baixar o audio de um link do YouTube e salvar em
MP3.

> Use apenas para conteudos que voce tem direito de baixar.

## Requisitos

- Python 3.9 ou superior
- FFmpeg instalado e disponivel no `PATH`

## Instalacao no Windows

Clone o repositorio e entre na pasta do projeto:

```powershell
git clone https://github.com/caiocdias/baixar_audio_youtube
cd baixar_audio_youtube
```

Crie um ambiente virtual:

```powershell
python -m venv venv
```

Ative o ambiente virtual:

```powershell
.\venv\Scripts\Activate.ps1
```

Atualize o `pip` e instale as dependencias:

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Instale o FFmpeg no Windows usando o pacote Gyan.FFmpeg:

```powershell
winget install Gyan.FFmpeg
```

Feche e abra o terminal novamente, se necessario, e confirme a instalacao:

```powershell
ffmpeg -version
```

## Uso

Baixar um video e salvar o MP3 na pasta atual:

```powershell
python baixar_audio_youtube.py "https://www.youtube.com/watch?v=VIDEO_ID"
```

Definir uma pasta de saida relativa:

```powershell
python baixar_audio_youtube.py "URL_DO_YOUTUBE" -o musicas
```

Definir uma pasta de saida absoluta:

```powershell
python baixar_audio_youtube.py "URL_DO_YOUTUBE" --output "C:\Users\SeuUsuario\Music"
```

Escolher a qualidade do MP3:

```powershell
python baixar_audio_youtube.py "URL_DO_YOUTUBE" --qualidade 320
```

Permitir o download de uma playlist:

```powershell
python baixar_audio_youtube.py "URL_DA_PLAYLIST" --playlist -o musicas
```

## Argumentos

| Argumento | Descricao |
| --- | --- |
| `url` | Link do video do YouTube. |
| `-o`, `--output` | Pasta onde o MP3 sera salvo. Aceita caminho relativo ou absoluto. |
| `-q`, `--qualidade` | Qualidade do MP3 em kbps. Padrao: `192`. |
| `--playlist` | Permite baixar playlists. Sem essa opcao, baixa apenas um video. |

## Autor

Desenvolvido por Caio Cezar Dias.

Contato: caiocd007@gmail.com
