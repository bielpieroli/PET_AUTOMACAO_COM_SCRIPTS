# --- VIRTUALENV ---
function entrarVenv {
    local current_dir="$PWD"
    if source ~/Documents/GitHub/venv.sh 2>/dev/null; then
        export VIRTUAL_ENV_DISABLE_PROMPT=1
        cd "$current_dir"
    else
        echo "Virtualenv não encontrado"
    fi
}

function sairVenv {
    if command -v deactivate >/dev/null 2>&1; then
        deactivate
        unset VIRTUAL_ENV
    else
        echo "Nenhum venv ativo"
    fi
}