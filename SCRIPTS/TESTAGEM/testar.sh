#!/bin/bash

# Verifica se o programa e a pasta de testes foram passados como argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <programa> <pasta_de_testes>"
    exit 1
fi

programa=$1
pasta_testes=$2

# Verifica se o executável existe
if [ ! -x "$programa" ]; then
    echo "Erro: Programa '$programa' não encontrado ou não é executável."
    exit 1
fi

# Verifica se a pasta de testes existe
if [ ! -d "$pasta_testes" ]; then
    echo "Erro: Pasta de testes '$pasta_testes' não encontrada."
    exit 1
fi

# Contadores para os resultados
PASSARAM=0
FALHARAM=0
ERROS_VALGRIND=0
LEAKS_DETECTED=0

# Itera sobre os arquivos de teste na pasta (ordenando numericamente)
for entrada in $(ls "$pasta_testes/in"/*.in | sort -V); do
    nome_base=$(basename "$entrada" .in)
    saida_esperada="$pasta_testes/out/$nome_base.out"

    # Verifica se o arquivo de saída esperada existe
    if [ ! -f "$saida_esperada" ]; then
        echo "Aviso: Arquivo de saída esperado '$saida_esperada' não encontrado. Pulando teste."
        continue
    fi

    # Executa o programa com Valgrind e verifica se há erros de memória
    echo "============================================="
    echo "Executando teste '$nome_base' com Valgrind..."
    echo "============================================="
    
    # Arquivos temporários
    saida_obtida="saida_obtida_$nome_base.tmp"
    valgrind_log="valgrind_log_$nome_base.tmp"
    
    # Executa com Valgrind com opções mais detalhadas
    valgrind --leak-check=full \
             --show-leak-kinds=all \
             --track-origins=yes \
             --errors-for-leak-kinds=definite,possible \
             --error-exitcode=1 \
             --log-file="$valgrind_log" \
             ./"$programa" < "$entrada" > "$saida_obtida"
    valgrind_status=$?

    # Extrai informações do HEAP SUMMARY
    allocs=$(grep "total heap usage:" "$valgrind_log" | awk '{print $5}')
    frees=$(grep "total heap usage:" "$valgrind_log" | awk '{print $7}')
    bytes_allocated=$(grep "total heap usage:" "$valgrind_log" | awk '{print $9}')

    # Verifica erros do Valgrind 
    if [ $valgrind_status -ne 0 ]; then
        echo "🔴 Teste '$nome_base': FALHOU (erros de memória detectados pelo Valgrind)"
        cat "$valgrind_log"
        ERROS_VALGRIND=$((ERROS_VALGRIND + 1))
        FALHARAM=$((FALHARAM + 1))
        rm -f "$saida_obtida" "$valgrind_log"
        continue
    fi


    # Verifica se há memory leaks (incluindo alloc/free mismatch)
    leak_detected=0
    leak_message=""
    
    # Verifica leaks tradicionais
    if grep -q "definitely lost: [1-9]" "$valgrind_log" || \
       grep -q "indirectly lost: [1-9]" "$valgrind_log"; then
        leak_message="Memory leaks detectados"
        leak_detected=1
    fi
    
    # Verifica desbalanço alloc/free
    if [ "$allocs" != "$frees" ]; then
        if [ -n "$leak_message" ]; then
            leak_message+=" + "
        fi
        leak_message+="Desbalanço alloc/free ($allocs allocs vs $frees frees)"
        leak_detected=1
    fi



    # Compara a saída obtida com a saída esperada, ignorando espaços e quebras de linha extras
    if diff -w -B -q "$saida_obtida" "$saida_esperada" > /dev/null; then
        if [ $leak_detected -eq 1 ]; then
            echo "⚠️  Teste '$nome_base': $leak_message"
            cat "$valgrind_log"
            LEAKS_DETECTED=$((LEAKS_DETECTED + 1))
        else
            echo "✅ Teste '$nome_base': SUCESSO"
            PASSARAM=$((PASSARAM + 1))
        fi
    else
        echo "❌ Teste '$nome_base': FALHOU"
        echo "------------------------------------------------"
        echo "--- Diferenças notadas pelo número da linha: ---"
        diff -w -B -y --width=120 --suppress-common-lines \
         <(nl -ba "$saida_esperada") \
         <(nl -ba "$saida_obtida") | \
         awk '{printf "%-40s | %s\n", $0, ""}' 
        echo "------------------------------------------------"
        FALHARAM=$((FALHARAM + 1))
    fi

    # Limpa os arquivos temporários
    rm -f "$saida_obtida" "$valgrind_log"
done

# Exibir resumo dos resultados
echo "============================================="
echo "Resumo dos Resultados:"
echo "============================================="
[ "$PASSARAM" -ne 0 ] && echo "✅ Passaram: $PASSARAM"
[ "$FALHARAM" -ne 0 ] && echo "❌ Falharam: $FALHARAM"
[ "$ERROS_VALGRIND" -ne 0 ] && echo "🔴 Erros de memória críticos: $ERROS_VALGRIND"
[ "$LEAKS_DETECTED" -ne 0 ] && echo "⚠️  Memory leaks detectados: $LEAKS_DETECTED"
echo "============================================="
