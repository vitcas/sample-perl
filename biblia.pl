#!/usr/bin/perl
use strict;
use warnings;
use List::Util 'shuffle';  # Para embaralhar o array

# Array de versículos bíblicos (adicione mais conforme necessário)
my @versiculos = (
    "João 3:16 - Porque Deus amou o mundo de tal maneira que deu o seu Filho unigênito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.",
    "Salmos 23:1 - O Senhor é o meu pastor; nada me faltará.",
    "Filipenses 4:13 - Tudo posso naquele que me fortalece.",
    "Mateus 5:9 - Bem-aventurados os pacificadores, porque serão chamados filhos de Deus.",
    "Provérbios 3:5 - Confia no Senhor de todo o teu coração, e não te estribes no teu próprio entendimento.",
    "Romanos 8:28 - Sabemos que todas as coisas cooperam para o bem daqueles que amam a Deus, daqueles que são chamados segundo o seu propósito."
);

# Seleciona um versículo aleatório
my $versiculo_aleatorio = (shuffle @versiculos)[0];

# Imprime o versículo
print "Versículo aleatório: $versiculo_aleatorio\n";
