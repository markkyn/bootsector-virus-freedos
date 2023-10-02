# BootSectorVirus - FreeDOS

## Contexto:
Esse projeto, realizado no período 2023.1 da Universidade Federal de Sergipe para disciplina de Interface Hardware-Software, tem como objetivo criar um virus de seção de boot (BootSector) que seja executado e persistido em uma imagem de FreeDOS. 

O projeto utiliza majoritariamente conceitos de Computação em Baixo Nível aprendidos em sala de aula.

- O projeto sera montado em NASM e será utilizado Bochs para emulação do projeto
- Duração de 4 semanas até a apresentação do trabalho.


## Instruções de Instalação e Execução do Virus:
### Realize a instalação da imagem do FreeDOS:
- Baixa a imagem ISO do FreeDOS (FD13LIVE.iso)
- Utilizando "**qemu-img**" crie uma imagem virtual de 100MB no diretório **./src/freedos/freedos.img** , esse será o arquivo utilizado para instalação e infecção do FreeDOS.

```shell
qemu-img create ../freedos/freedos.img 100M
```    

- Agora faça o boot da ISO pelo cdroom com a imagem virtual criada no passo anterior

```shell
qemu-system-i386 -hda freedos.img -cdrom FD13LIVE.iso -m 16 -boot order=d -enable-kvm
```

- Realize a instalação do FreeDOS

- Com a instalação do FreeDOS realizada, realize o boot pelo Driver C:/ 
```shell
qemu-system-i386 -hda ../freedos/freedos.img -m 16 -boot order=c -enable-kvm
```

### Execução do Virus:
- Uma vez no repositório, acesse o diretorio:
```shell
cd ./src/virus
```

- Realize o Backup da imagem FreeDOS
```shell
./backup.sh
```

- Realize a montagem do floppydisk
```shell
./infect_floppydisk.sh
```

- Execute o virus
```shell
./virus.sh
```

### Análise de Infecção
Utilizando algum 

