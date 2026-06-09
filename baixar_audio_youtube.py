#!/usr/bin/env python3
"""
Baixa o audio de um video do YouTube e converte para MP3.

Uso:
    python baixar_audio_youtube.py "https://www.youtube.com/watch?v=VIDEO_ID"
    python baixar_audio_youtube.py "URL" -o musicas --qualidade 192

Dependencias:
    python -m pip install -U yt-dlp
    ffmpeg instalado e disponivel no PATH
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


def importar_yt_dlp():
    try:
        import yt_dlp  # type: ignore
    except ModuleNotFoundError:
        print(
            "Erro: o pacote 'yt-dlp' nao esta instalado.\n"
            "Instale com: python -m pip install -U yt-dlp",
            file=sys.stderr,
        )
        sys.exit(1)

    return yt_dlp


def validar_ffmpeg() -> None:
    if shutil.which("ffmpeg") is None:
        print(
            "Erro: o ffmpeg nao foi encontrado no PATH.\n"
            "Instale o ffmpeg e tente novamente. No Windows, uma opcao e:\n"
            "  winget install Gyan.FFmpeg",
            file=sys.stderr,
        )
        sys.exit(1)


def baixar_audio(url: str, pasta_saida: Path, qualidade: str, permitir_playlist: bool) -> None:
    yt_dlp = importar_yt_dlp()
    validar_ffmpeg()

    pasta_saida.mkdir(parents=True, exist_ok=True)

    opcoes = {
        "format": "bestaudio/best",
        "outtmpl": str(pasta_saida / "%(title).200B.%(ext)s"),
        "noplaylist": not permitir_playlist,
        "ignoreerrors": permitir_playlist,
        "windowsfilenames": True,
        "postprocessors": [
            {
                "key": "FFmpegExtractAudio",
                "preferredcodec": "mp3",
                "preferredquality": qualidade,
            }
        ],
    }

    try:
        with yt_dlp.YoutubeDL(opcoes) as ydl:
            resultado = ydl.download([url])
            if resultado and permitir_playlist:
                print(
                    "Aviso: um ou mais itens da playlist falharam e foram pulados.",
                    file=sys.stderr,
                )
            elif resultado:
                sys.exit(resultado)
    except Exception as exc:
        print(f"Erro ao baixar/converter audio: {exc}", file=sys.stderr)
        sys.exit(1)


def criar_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Baixa o audio de um link do YouTube e salva em MP3."
    )
    parser.add_argument("url", help="Link do video do YouTube")
    parser.add_argument(
        "-o",
        "--output",
        default=".",
        help="Pasta onde o MP3 sera salvo. Padrao: pasta atual",
    )
    parser.add_argument(
        "-q",
        "--qualidade",
        default="192",
        choices=["64", "96", "128", "160", "192", "256", "320"],
        help="Qualidade do MP3 em kbps. Padrao: 192",
    )
    parser.add_argument(
        "--playlist",
        action="store_true",
        help=(
            "Permite baixar playlists. Por padrao, baixa apenas um video. "
            "Itens com erro sao pulados."
        ),
    )
    return parser


def main() -> None:
    args = criar_parser().parse_args()
    baixar_audio(
        url=args.url,
        pasta_saida=Path(args.output).expanduser().resolve(),
        qualidade=args.qualidade,
        permitir_playlist=args.playlist,
    )


if __name__ == "__main__":
    main()
