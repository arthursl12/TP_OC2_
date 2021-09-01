# Instruções de Compilação/Execução e Testes
* Para compilar o processador e as testbenches execute o script *build.sh*. Entre na pasta raiz do processador desejado e o execute: 

        bash build.sh
* Para executar um teste e gerar um arquivo *.vcd* para análise das ondas no GTKWave, a partir da pasta *build*, invoque o *vvp* no arquivo compilado (*.out*) daquela testbench desejada, por exemplo:

        vvp riscv_tb1_addi.out
O arquivo *.vcd* com as formas de onda estará nessa mesma pasta. Lembre-se de verificar os avisos impressos na tela, antes das saídas dos sinais, para checar se não ocorreu algum erro de leitura de algum arquivo auxiliar, que pode ocorrer devido à imprecisões de caminhos.
Em posse das formas de onda, é possível visualizá-la com um programa como o GTKWave.

        gtkwave riscv_tb1_addi.vcd
