!/bin/bash

# array frutas
frutas=("🍒cerezas🍒" "🍍piña🍍" "🍉sandía🍉" "🍎manzana🍎")

# Puntuación inicial del usuario
puntos=10
avances=0

# Función para obtener una fruta aleatoria
funcion_fruta_aleatoria() {
    local indice=$((RANDOM % ${#frutas[@]}))
    echo "${frutas[$indice]}"
}

# Función para generar una combinación aleatoria
funcion_generar_combinacion() {
    combinacion=()

    for ((i=0; i<3; i++)); do
        fruta=$(funcion_fruta_aleatoria)
        combinacion+=("$fruta")
    done

    echo "${combinacion[*]}"
}

# Función para comprobar si la combinación es ganadora
es_combinacion_ganadora() {
    local combinacion=("$@")

    if [[ "${combinacion[0]}" == "${combinacion[1]}" && "${combinacion[0]}" == "${combinacion[2]}" ]]; then
        return 0
    else
        return 1
    fi
}

# Función para mostrar el menú y obtener la opción del usuario
mostrar_menu() {
    echo "-------------------------"
    echo "Crédito disponible: $puntos"
    echo "-------------------------"
    echo "1. Jugar a la tragaperras"
    echo "2. Salir"
    read -p "Selecciona una opción: " opcion

    case $opcion in
        1)
            if [[ $puntos -gt 0 ]]; then
                jugar_tragaperras
            else
                echo "------------------------------------------------"
                echo "Te has arruinado. Vuelve cuando tengas dinero!!!"
                echo "------------------------------------------------"
                exit 0
            fi
            ;;
        2)
            echo "-------------"
            echo "¡Hasta luego!"
            echo "-------------"
            exit 0
            ;;
        *)
            echo "---------------"
            echo "Opción inválida"
            echo "---------------"
            mostrar_menu
            ;;
    esac
}

# Función principal

jugar_tragaperras() {
    combinacion=($(funcion_generar_combinacion))
    clear
    echo "----------------------------------------------------------------------"
    echo "COMBINACIÓN GANADORA: ${combinacion[*]}"

    if [[ "${combinacion[0]}" == "${combinacion[1]}" && "${combinacion[0]}" == "${combinacion[2]}" ]]; then  
        echo "----------------------------------------------------------------------"
        echo "¡FELICIDADES!"
        echo "Has ganado tres créditos"
        echo "----------------------------------------------------------------------"
        puntos=$((puntos + 3))
    else
        if [[ "${combinacion[0]}" == "${combinacion[1]}" || "${combinacion[0]}" == "${combinacion[2]}" || "${combinacion[1]}" == "${combinacion[2]}" ]]; then
            echo "----------------------------------------------------------------------"
            echo "¡Hay frutas iguales en la combinación!"
            echo "¿Deseas utilizar un avance? (S/N)"
            read -r opcion_avance

            if [[ "$opcion_avance" == "S" || "$opcion_avance" == "s" ]]; then
                posicion_no_igual=-1

                if [[ "${combinacion[0]}" != "${combinacion[1]}" && "${combinacion[0]}" != "${combinacion[2]}" ]]; then
                    posicion_no_igual=0
                elif [[ "${combinacion[1]}" != "${combinacion[0]}" && "${combinacion[1]}" != "${combinacion[2]}" ]]; then
                    posicion_no_igual=1
                else
                    posicion_no_igual=2
                fi

                if [[ $posicion_no_igual != -1 ]]; then
                    fruta_nueva=$(funcion_fruta_aleatoria)
                    combinacion[$posicion_no_igual]=$fruta_nueva
                fi

                echo "----------------------------------------------------------------------"
                echo "NUEVA COMBINACIÓN: ${combinacion[*]}"

                if [[ "${combinacion[0]}" == "${combinacion[1]}" && "${combinacion[0]}" == "${combinacion[2]}" ]]; then  
                    echo "----------------------------------------------------------------------"
                    echo "¡FELICIDADES!"
                    echo "Has ganado tres créditos"
                    echo "----------------------------------------------------------------------"
                    puntos=$((puntos + 3))
                else
                    echo "----------------------------------------------------------------------"
                    echo "Lo siento, has perdido un crédito"
                    echo "----------------------------------------------------------------------"
                    puntos=$((puntos - 1))
                fi
            fi
        else
            echo "----------------------------------------------------------------------"
            echo "Lo siento, has perdido un crédito"
            echo "----------------------------------------------------------------------"
            puntos=$((puntos - 1))
        fi
    fi

    read -p "Presiona Intro para continuar..."
    clear
    mostrar_menu
}


# Llamada inicial al menú
clear
mostrar_menu
