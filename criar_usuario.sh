#!/bin/bash

# Exibir grupos existentes:
show_group(){
    clear
        echo "Grupos existentes:"
        echo "_____________________________"
        egrep [1][0-9]{3} /etc/group | cut -d: -f1
        echo "_____________________________"
}
grupos(){
    create_group(){
        show_group
        read -p "Qual o nome do grupo: " name_group \n
        if sudo groupadd $name_group; then
            echo "[Ok] grupo [$name_group] foi criado"
            echo "-------------------------------------------------------"
	fi
    }

    while test 1; do
        echo -en "Escolha uma opção:\n\n\t1) Criar grupos\n\t2) Exibir grupos \n\t3) Sair\n\nOpção: "
        read OPCAO

        case $OPCAO in
            1) create_group;;
            2) show_group;;
            3) menu;;
            *) echo -e "\n\nOpção inválida! Tecle enter para continuar..."; read;;
        esac

    done
}

show_user(){
   # Exibir usuários existentes:
    clear
	echo "Usuário(s) existente(s):"
	echo "_____________________________"
  	    egrep [1][0-9]{3} /etc/passwd | cut -d: -f1
	echo "_____________________________"
}

usuario(){
    create_user(){
   # Nome:
        echo -e "\n(Dica: Não coloque espaço e alguns caracteres especiais)\n"
            read -p "Crie um usuário: " novo_usuario
   # Senha:
	pass(){
    	read -p "Digite a senha: " -s senha1
            echo -e "\nRedigite a senha: "
            	read -s senha2
   # Verifincando senha:	
                if [ $senha1 != $senha2 ]; then
                    while [ $senha1 != $senha2 ]; do
                    clear
                        echo " ______________________________"
                            echo "|A senha não é igual; tente novamente|"
                            echo -e "|______________________________|\n"
                            pass
                    done
                fi
    }
    pass
   # Criando o usuário:
        if sudo useradd -m $novo_usuario -p $(openssl passwd -1 $senha1) -s /bin/bash; then
            clear
                echo "[Ok] usuário [$novo_usuario] foi criado"
                echo "-------------------------------------------------------"
        else
            clear
                echo "[Erro] ao criar o usuário [$novo_usuario]"
                echo "-------------------------------------------------------"
        fi
    }
    add_at_group(){
        show_user
        show_group
        read -p "Qual o nome do usuario? " user_name
        read -p "Qual grupo atribuir o usuario? " user_group
        if sudo gpasswd -a $user_name $user_group; then
                echo "[Ok] usuário [$user_name] foi atribuido ao grupo $user_group"
                echo "-------------------------------------------------------"
        else
            clear
                echo "[Erro] ao atribuir o usuário [$user_name]"
                echo "-------------------------------------------------------"
        fi

    }
    while test 1; do
        echo -en "Escolha uma opção:\n\n\t1) Criar Usuário \n\t2) Exibir Usuário \n\t3) Adicionar ao Grupo \n\t4) Sair\n\nOpção: "
        read OPCAO
        case $OPCAO in
            1) create_user;;
            2) show_user;;
            3) add_at_group;;
            4) menu;;
            *) echo -e "\n\nOpção inválida! Tecle enter para continuar..."; read;;
        esac
    done
}
menu(){
    while test 1; do
        clear
        echo -en "Escolha uma opção:\n\n\t1) Grupos \n\t2) Usuários \n\t3) Sair \n\nOpção: "
        read OPCAO

        case $OPCAO in
            1) grupos;;
            2) usuario;;
            3) exit;;
            *) echo -e "\n\nOpção inválida! Tecle enter para continuar..."; read;;
        esac

    done
}
menu
