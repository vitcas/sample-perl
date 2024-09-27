#!/usr/bin/perl
use strict;
use warnings;

# Gera um número aleatório entre 1 e 100
my $secret_number = int(1 + rand 100);
my $attempts = 0;

print "Bem-vindo ao jogo 'Adivinhe o Número'!\n";
print "Eu escolhi um número entre 1 e 100. Tente adivinhar!\n";

# Loop principal do jogo
while (1) {
    print "Digite seu palpite: ";
    my $guess = <STDIN>;  # Lê a entrada do usuário
    chomp $guess;         # Remove a nova linha no final da string
    $attempts++;

    # Verifica se o palpite é válido
    if ($guess !~ /^\d+$/) {
        print "Por favor, insira um número válido.\n";
        next;
    }

    # Verifica o palpite
    if ($guess == $secret_number) {
        print "Parabéns! Você acertou o número em $attempts tentativas!\n";
        last;
    } elsif ($guess < $secret_number) {
        print "O número é maior.\n";
    } else {
        print "O número é menor.\n";
    }
}

print "Obrigado por jogar!\n";