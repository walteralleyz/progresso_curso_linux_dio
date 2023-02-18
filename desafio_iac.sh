#!/bin/bash

echo "Iniciando script"
echo "Configuracao de diretorios, usuarios e permissoes"

apagar_usuario=1
dirs=('publico' 'adm' 'ven' 'sec')
grupos=('GRP_ADM' 'GRP_VEN' 'GRP_SEC')
novos_usuarios_adm=('Carlos' 'Maria' 'Joao')
novos_usuarios_ven=('Debora' 'Sebastiana' 'Roberto')
novos_usuarios_sec=('Josefina' 'Amanda' 'Rogerio')

while [ $apagar_usuario == 1 ]
do
    echo "Apagar um usuario? (1=sim; 0=nao)"
    read apagar_usuario

    if [ $apagar_usuario == 1 ]
    then
        echo "Digite o usuario:"
        read usuario
        $(userdel $usuario)
    fi
done

echo "Preparando para criar novos diretorios"

mkdir desafio

function criar_usuario() {
    echo "Criando grupo $4"
    $(groupadd $4)

    echo "Criando usuarios de $5"

    for user in $1
    do
       echo "Alterando dono e grupo do diretorio"
       $(chown root:$4 $5)

       echo "Criando usuario $user"

       useradd $user -G $4 -s /bin/bash -p $(openssl passwd -crypt Senha123)
    done
}

function alterar_permissao_dir() {
    echo "Alterando permissoes do diretorio $1"
    $(chmod 770 $1)
}

for dir in ${dirs[@]}
do
    echo "Criando diretorio $dir"
    mkdir desafio/$dir

    alterar_permissao_dir desafio/$dir
done

criar_usuario ${novos_usuarios_adm[@]} GRP_ADM adm
criar_usuario ${novos_usuarios_ven[@]} GRP_VEN ven
criar_usuario ${novos_usuarios_sec[@]} GRP_SEC sec

echo "Encerrando script com sucesso!"
