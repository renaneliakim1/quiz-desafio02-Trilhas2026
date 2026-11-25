Desafio 2 — Fazendo meu Quiz com Dart
Sua missão é criar um jogo de perguntas e respostas (quiz) utilizando Dart, que deverá funcionar no terminal do computador.

LINK DO VÍDEO DE EXPLICAÇÃO:
https://drive.google.com/file/d/1RlG9q5cgBmHwCS-LW5rH-yv_GRvmOrFu/view?usp=sharing


Em dupla ou individualmente, vocês deverão escolher o tema do quiz, elaborar as perguntas e definir as alternativas. Pode ser sobre futebol, filmes, séries, jogos, ciências, música, curiosidades ou outro assunto de interesse.

O programa deverá apresentar as perguntas, receber as respostas do jogador, verificar se estão corretas e, ao final, mostrar a pontuação e uma mensagem de acordo com o desempenho.

1. Criação do Quiz

O jogo deverá apresentar:

Nome do quiz e uma breve mensagem de boas-vindas.
Pelo menos cinco perguntas relacionadas ao tema escolhido.
Cada pergunta deverá ter quatro alternativas (A, B, C e D), sendo apenas uma correta.
Identificação do jogador pelo nome.
Escolham um tema que seja interessante e utilizem a criatividade para personalizar as mensagens e a apresentação do jogo no terminal.

2. Funcionamento com Dart

Ao executar o programa, o jogo deverá:

Perguntar o nome do jogador e utilizá-lo nas mensagens.
Apresentar cada pergunta com suas quatro alternativas.
Receber a resposta digitada utilizando stdin.readLineSync().
Verificar se a resposta está correta ou incorreta.
Informar quando o jogador acertar e, em caso de erro, apresentar a alternativa correta.
Contabilizar os acertos e mostrar a pontuação final, por exemplo: 4 de 5 perguntas corretas.
Exibir uma mensagem final que varie conforme o desempenho do jogador.
As perguntas deverão ser armazenadas em uma lista, e o programa deverá utilizar uma estrutura de repetição for para apresentá-las, uma de cada vez.

O jogo também deverá:

Aceitar respostas em letras maiúsculas ou minúsculas, como A ou a.
Solicitar uma nova resposta caso o jogador digite uma alternativa inválida ou pressione Enter sem responder.
Utilizar estruturas condicionais para verificar as respostas.
Não será permitido programar cada pergunta separadamente. O código deverá utilizar a lista e a repetição para controlar o funcionamento do quiz.

Funcionalidades extras (opcionais)

A dupla também poderá adicionar funcionalidades para tornar o jogo mais completo, como:

Embaralhar a ordem das perguntas.
Permitir que o jogador escolha jogar novamente.
Criar diferentes níveis de dificuldade.
Apresentar um ranking de jogadores e pontuações.
Essas funcionalidades são opcionais e poderão contribuir positivamente para a avaliação.

3. Arquivos e documentação

Criem o projeto utilizando o comando dart create e mantenham a estrutura de arquivos gerada pelo Dart.

O código principal deverá ficar na pasta bin, enquanto a pasta lib poderá ser utilizada para organizar perguntas, funções e outras partes do programa.

O projeto deverá funcionar corretamente por meio do comando dart run, executado dentro da pasta do projeto.

Incluam um README.md com:

Nome do projeto, dos dois integrantes e da trilha.
Apresentação do quiz, tema escolhido e exemplo de pergunta.
Se utilizarem IA, expliquem como ajudou, o que vocês adaptaram e como verificaram o resultado.

O desenvolvimento deverá ser registrado no GitHub, com commits realizados ao longo da construção do projeto, e não somente ao final.

4. Testes do jogo

Antes de entregar, executem o quiz algumas vezes para verificar:

Se todas as perguntas e alternativas aparecem corretamente.
Se o programa identifica respostas certas e erradas.
Se as respostas incorretas apresentam a alternativa correta.
Se letras maiúsculas e minúsculas são aceitas.
Se respostas inválidas são tratadas corretamente.
Se a pontuação final corresponde à quantidade de acertos.
Regras

Modalidade: em dupla.
Data de entrega: 28/11/2026 às 23:59.
Forma de entrega: cada integrante deverá enviar somente o link do repositório do GitHub na atividade do Desafio 2, disponível na plataforma +Robotic.
Repositório: deverá ser público, com todos os arquivos do projeto e o README.md atualizado.
Avaliação

Serão considerados o funcionamento do quiz, a utilização dos conceitos de Dart (listas, estruturas de repetição, condicionais e funções), a validação das respostas, a organização do código, a apresentação do jogo e a documentação do projeto.

As funcionalidades extras também serão consideradas positivamente, desde que os requisitos obrigatórios estejam funcionando corretamente.