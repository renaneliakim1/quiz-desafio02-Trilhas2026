# Quiz de Programação - Desafio 2

## Sobre o projeto

Este é um quiz de perguntas e respostas executado no terminal, desenvolvido em
Dart para o Desafio 2. O tema escolhido foi **programação**, com perguntas
separadas entre **linguagens** (JavaScript, Java, Kotlin, Dart e Swift) e
**bibliotecas/frameworks** (React, React Native e Flutter).

O jogo sorteia **10 perguntas por partida**, apresenta quatro alternativas
(A, B, C e D), valida a resposta do jogador e mostra a alternativa correta
quando houver erro. Ao final, exibe a pontuação, uma mensagem de desempenho e
salva o resultado no ranking.

## Funcionalidades

- 96 perguntas divididas em três níveis de dificuldade: Fácil, Intermediário e Difícil.
- 4 perguntas de cada tecnologia em cada dificuldade, reduzindo a repetição entre partidas.
- Tecnologias separadas entre **linguagens** e **bibliotecas/frameworks**.
- Escolha da área do quiz: todas as tecnologias, somente linguagens ou somente bibliotecas.
- Modo **Misto**, que combina perguntas de todas as dificuldades.
- Cada partida tem 10 perguntas, sorteadas sem repetição e com cobertura de todas as tecnologias da área escolhida.
- Alternativas embaralhadas a cada partida.
- Respostas aceitas em maiúsculas ou minúsculas (`A` ou `a`).
- Respostas vazias ou inválidas são recusadas e o jogador responde novamente.
- Explicação da resposta após cada pergunta.
- Mensagem final personalizada conforme o percentual de acertos.
- Ranking salvo em `ranking.json`, ordenado por percentual e quantidade de acertos.
- Opção de jogar novamente sem reiniciar o programa.
- Opção de limpar o ranking.

## Como executar

Pré-requisitos: Dart 3.13 ou superior.

```bash
dart pub get
dart run
```

Caso o comando `dart` não esteja no PATH no Windows, use o caminho da instalação:

```powershell
C:\flutter\bin\dart.bat run
```

## Como jogar

1. No menu principal, escolha `[1] Jogar`.
2. Digite seu nome.
3. Escolha a dificuldade: Fácil, Intermediário, Difícil ou Misto.
4. Escolha a área: todas as tecnologias, somente linguagens ou somente bibliotecas e frameworks.
5. Responda as 10 perguntas digitando `A`, `B`, `C` ou `D`.
6. Confira a pontuação e a mensagem final.
7. Acesse `[2] Ver ranking` para consultar as melhores partidas.

## Exemplo de pergunta

```text
Pergunta 1/10  [Dart]  (Fácil)

Qual palavra-chave declara uma constante conhecida em tempo de compilação?

  A) final
  B) const
  C) var
  D) late

Sua resposta: b
Correto! const cria uma constante em tempo de compilação, enquanto final é definida em tempo de execução.
```

## Estrutura do projeto

```text
bin/
  quiz_programacao.dart        Ponto de entrada do programa
lib/
  quiz_programacao.dart        Exporta as APIs do projeto
  src/
    data/
      question_bank.dart       Lista com as 96 perguntas
    models/
      difficulty.dart          Níveis de dificuldade
      question.dart            Modelo de uma pergunta
      score_entry.dart         Modelo de uma partida do ranking
      topic.dart               Tecnologias e categorias (linguagem/biblioteca)
    services/
      quiz_engine.dart         Sorteio e embaralhamento das perguntas
      ranking_service.dart     Leitura e gravação do ranking em JSON
    ui/
      console.dart             Entrada, saída e cores do terminal
      quiz_app.dart            Fluxo do jogo e menus
test/
  question_bank_test.dart      Testes do banco, do motor e do ranking
pubspec.yaml
ranking.json                   Gerado automaticamente ao final de cada partida
```

## Ranking

Cada partida concluída é adicionada a uma lista persistida no arquivo
`ranking.json`, na pasta em que o programa foi executado. A lista é ordenada
por percentual de acertos e, em caso de empate, pela quantidade de acertos.

O arquivo é criado automaticamente e não é versionado no Git. Se ele for
apagado, o ranking começa vazio novamente. A opção de limpar o ranking também
remove o arquivo.

## Testes

Para executar os testes automatizados:

```bash
dart test
```

Os testes verificam:

- quantidade mínima de perguntas por dificuldade e por tecnologia;
- quatro alternativas válidas e explicação em todas as perguntas;
- identificadores únicos e cobertura de todas as tecnologias;
- separação correta entre linguagens e bibliotecas/frameworks;
- sorteio de 10 perguntas sem repetição, com todas as tecnologias;
- filtro por área (linguagens ou bibliotecas) mantendo a cobertura de tecnologias;
- presença das três dificuldades no modo Misto;
- embaralhamento das alternativas sem perder a resposta correta;
- serialização e ordenação das pontuações;
- gravação, leitura e limpeza do ranking.

Para verificar o estilo e erros de análise estática:

```bash
dart analyze
```

## Uso de IA

A IA foi utilizada como ferramenta de apoio durante o desenvolvimento: ajudou a
estruturar o projeto em pastas, sugerir o banco de perguntas, revisar mensagens e
apontar melhorias de organização e validação.

A dupla revisou e adaptou todo o conteúdo gerado, incluindo perguntas,
alternativas, explicações e textos da interface. O resultado foi verificado com
`dart analyze`, com os testes automatizados de `dart test` e com partidas
manuais no terminal, cobrindo respostas corretas, incorretas, maiúsculas,
minúsculas, entradas vazias, entradas inválidas e persistência do ranking.

## Checklist de testes manuais

- [ok] As perguntas e as quatro alternativas aparecem corretamente.
- [ok] Respostas corretas e incorretas são identificadas.
- [ok] Em caso de erro, a alternativa correta é exibida.
- [ok] Letras maiúsculas e minúsculas são aceitas.
- [ok] Respostas inválidas ou vazias solicitam uma nova resposta.
- [ok] A pontuação final corresponde à quantidade de acertos.
- [ok] O ranking é salvo e exibido na ordem correta.
- [ok] É possível jogar novamente e voltar ao menu.
