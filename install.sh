#!/bin/bash

if (( $EUID != 0 )); then
    echo "❌ Harap jalankan sebagai root!"
    exit
fi

clear
PANEL_DIR="/var/www/pterodactyl"
BACKUP_NAME="Pterodactyl_Nightcore_Themebackup.tar.gz"
CUSTOM_BG_URL="https://github.com/miku208/Img/blob/main/IMG-20250626-WA0197.jpg?raw=true"

installTheme(){
    echo "📦 Membuat backup..."
    cd /var/www/
    tar -cvf $BACKUP_NAME pterodactyl

    echo "🚧 Menginstal tema Nightcore..."
    cd $PANEL_DIR
    rm -rf Pterodactyl_Nightcore_Theme
    git clone https://github.com/NoPro200/Pterodactyl_Nightcore_Theme.git
    cd Pterodactyl_Nightcore_Theme

    echo "🧹 Menghapus file lama..."
    rm -f $PANEL_DIR/resources/scripts/Pterodactyl_Nightcore_Theme.css
    rm -f $PANEL_DIR/resources/scripts/index.tsx

    echo "📁 Menyalin file tema baru..."
    cp index.tsx $PANEL_DIR/resources/scripts/index.tsx
    cp Pterodactyl_Nightcore_Theme.css $PANEL_DIR/resources/scripts/Pterodactyl_Nightcore_Theme.css

    echo "🎨 Mengganti background dengan foto kamu..."
    sed -i "s|background-image: url([^)]*);|background-image: url('$CUSTOM_BG_URL');|g" $PANEL_DIR/resources/scripts/Pterodactyl_Nightcore_Theme.css

    echo "🔧 Setup nodejs..."
    curl -sL https://deb.nodesource.com/setup_18.x | bash -
    apt update -y
    apt install -y nodejs

    echo "⚙️ Build ulang tema..."
    cd $PANEL_DIR
    yarn install
    yarn build:production
    php artisan optimize:clear

    echo "✅ Tema Nightcore berhasil dipasang dengan background kustom!"
}

restoreBackup(){
    echo "♻️ Memulihkan dari backup..."
    cd /var/www/
    tar -xvf $BACKUP_NAME
    rm -f $BACKUP_NAME
    cd $PANEL_DIR
    yarn build:production
    php artisan optimize:clear
}

echo "━━━━━━━━━━━━━━━━━━━━━━━"
echo " Pterodactyl Nightcore Installer + Custom BG"
echo "━━━━━━━━━━━━━━━━━━━━━━━"
echo "[1] Install tema Nightcore + background kamu"
echo "[2] Restore dari backup"
echo "[3] Keluar"
echo "━━━━━━━━━━━━━━━━━━━━━━━"
read -p "Pilih opsi: " pilihan

case $pilihan in
    1) installTheme ;;
    2) restoreBackup ;;
    *) echo "Keluar." ;;
esac
