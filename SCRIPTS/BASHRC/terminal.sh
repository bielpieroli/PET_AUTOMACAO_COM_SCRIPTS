# Adicione essa função no arquivo ~/.bashrc
git_branch_name() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "🌿 $branch"
    fi
}

# Substitua onde falar de PS1 no ~/.bashrc por isso:
if [ "$color_prompt" = yes ]; then
   PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[33m\]$(git_branch_name)\[\033[00m\] ➜ '
else
   PS1='\u@\h:\w $(git_branch_name) ➜ '
fi

# A estilização da fonte é dada por:
# \[\033[<código>m\]
# Esse código segue o seguinte:
# 1) Códigos principais
# Reset: 0 (sempre use no final para não vazar cor).
# Negrito: 1
# Sublinhado: 4

# Cores de texto (foreground):
# Código	Cor
# 30	Preto
# 31	Vermelho
# 32	Verde
# 33	Amarelo
# 34	Azul
# 35	Roxo
# 36	Ciano
# 37	Branco

# TESTEM: echo -e "\033[31mVermelho \033[32mVerde \033[34mAzul\033[0m"
# TESTEM: echo -e "\033[31mVermelho \033[01;32mVerde \033[00m \033[04;34mAzul\033[0m" 
# Uma observação importante é que muitas vezes, temos que resetar o efeito, com o reset, do contrário, o efeito passa para todos os elementos à frente.

# Para mais estilizações, pode-se usar o starship
