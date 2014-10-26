package Acme::BOPE;

require 5.005_62;
#use strict;
#use warnings;

our $VERSION =  0.01;

#use Exporter;
#
#our @ISA = qw(Exporter);
#our @EXPORT = qw(canta_hino fato);

my @ignoradas = (
  "[dn]?[oa][s]?"       , # o, a, os, as, dos, nos, das, nas, no, na, do, da
  "[nd]?e(?:ss|l)[ae]s?", # ele, ela, dele, dela, desse, dessa nesse, nessa
  "s(?:eu|ua)s?"        , # seu, sua
  "(?:uma?|eu)"         , # uma, eu
  "com"                 ,
  "sem"                 ,
  "porra[?!]*"          ,
  "merda[?!]*"          ,
  "viado[?!]*"          ,
);

#my $ignoradas = join "|", @ignoradas;

use Filter::Simple;

FILTER_ONLY
  all => sub {
  my $package = shift;
  my %par = @_;
  
  if ( $par{'DEBUG'} ) {
    filter($_);
    Perl::Tidy::perltidy(source => \$_, destination => \$_)
        if eval "require Perl::Tidy";
    print;
  }
#  my $DEBUG = $par{DEBUG} if $par{DEBUG};
#  return unless $DEBUG;
#  filter($_);
#  Perl::Tidy::perltidy(source => \$_, destination => \$_)
#   if eval "require Perl::Tidy";
#  print if $DEBUG;
#  exit;
},
  code_no_comments  => \&filter;
sub filter {

  $_ = "\$senhor = \$\$_;$/" . $_;
  $_ = "\$| = 1;$/" . $_;
  s#pelot[�a]o, cantar hino#print Acme::BOPE::canta_hino#gi;
  s#Capit[�a]o Nascimento#print Acme::BOPE::fato#gi; # mudar por frase legal

  s{\b(?:naum|n�o|nao|nunca|jamais)\s+(?:ser(?:�|�o)|�|eh)\b}{ne}gi;
  s{\b(?:naum|n�o|nao|nunca|jamais)\b}{not}gi;
  s{\bser(?:�|�o|a|ah|ao)\b}{eq}gi;
  s{\b(?:�|eh)\b}{=}gi;
  s{\bfor\b}{eq}gi;

  s{\bvale(?:r�)?\b}{==}gi;

  s{\bvai pra guerra\b}{system}gi;

  s#\bse\s+(.*?)\s+ent[�a]o\b#if($1){\n#gi;
  s#\bent[�a]o\b#\{#gi;
  s#\bfaz isso aqui[:]?\b#\{#gi;
  s#\bsen[�a]o\b#}else{\n#gi;
  s#\bestamos entendidos[?!]*\b#}#gi;
  s#\bos? senhor(?:es)? est(?:[a�]o|[a�]) fazendo (?:o )?seu instrutor muito feliz(?:...)#}#gi;
  s{\bfala(?: agora)?[!:]*}{print}gi;
  s{\bgrita[!:]*\b}{print}gi;
  s{\bvai dar merda,?}{warn}gi;
  s{
    \b(?:v(?:ou|ai)\s+)?gritar\s+(?:em|n[oa]|ao?) (.*?):
   }
   {
    (my $file = $1) =~ s/\W/_/g;
    $file =~ s/^_+|_+$//g;
    my $fh = uc $file;
    "open $fh, \">>$file\";
     print \{$fh\}"
   }giex;

  s{\bchega[!]*\b}{last}gi;
  s{\bp�ra[!]*\b}{last}gi;

  s#\bpara\s+(.*?)\s+(?:ent[a�]o|,)fa[c�]a\b#for($1){#gi;
  s#\benquanto\s+(.*?)\s*,#while($1){\n#gi;

  s{\bfati(?:a|ou)\b}{split}gi;
  s{\bpass(?:a|ou)\b}{next}gi;

  s{\bpede pra sair\b}{die}gi;
  s{\b(?:eu )?desisto\b}{exit}gi;
  s{\bdesistiu\b}{= undef}gi;
  s{\bbota na conta do papa\b}{exit}gi;

  s{\be\b}{and}gi;
  s{\b(?:ent[�a]o\s+)?senta o dedo nessa porra\b}{print "Caveira meu capitao!"}gi;
 
  # variaveis
  no warnings;
  s#\bsenhor(?:\s+(\d{2,}))?,#\$senhor = \\\$_$1;\n#gi;
  use warnings;
  s{\b(?:senhor|o)\s+(\d{2,})\b}{sprintf"\$_%s ", defined $1?$1:""}gie;
  s{([^\$])senhor|voc[�e]}{$1\$\$senhor}gi;

  # perguntas
  s#(100\s*%\s+(\d{2,})?\?+)#
   print "$1";
   chomp(\$_$2 = <>);
   \$_$2 =~ /^100%|sim|s/ &&#gi;
  s#
    ((?:a?onde (?:es)t[a�]|cad[�e])\s+[oa]s?\s+(\w+)[?!]+)
   #
    my $var;
    ($var = $2) =~ s/\W/_/g;
    $var = lc($var);
    qq:
       print "$1";
       chomp(\$$var = <>);
       print "0" . (int(rand 9) + 1) . ", pega a vassoura!\$/";
      :;
   #gixe;

  my @quotes = m#"(.*?)"#gsm;
  s#"(.*?)"#sprintf qq/"%d"/, my $i++#gsme;

  # palavras que s�o ignoradas dentro do c�digo  
   foreach my $ignora (@ignoradas){
      s{\b$ignora\b}{}gi;
   }

  s#(?:(?:OK)?\s*[!?]+)#;#gi;
 
  s#"(\d+)"#"$quotes[$1]"#g;

};

# hinos do bope:
sub canta_hino {
    my $self = shift;
    my @hinos = (
         'O interrogat�rio � muito f�cil de fazer/pega o favelado e d� porrada at� doer/O interrogat�rio � muito f�cil de acabar/pega o bandido e d� porrada at� matar',
         'Esse sangue � muito bom/ j� provei n�o tem perigo/� melhor do que caf�/� o sangue do inimigo',
         'O quintal do inimigo/n�o se varre com vassoura/se varre com granada/com fuzil, metralhadora',
         'S�o os homens da caveira/do bornal e do cantil/Sua for�a combativa/est� na ponta do fuzil',
         'Cachorro latindo/Crian�a chorando/Vagabundo vazando/� o BOPE chegando',
         'Tropa de elite/osso duro de roer/Pega um, pega geral/tamb�m vai pegar voc�',
         'Homem de preto, qual � sua miss�o?/Entrar pela favela e deixar corpo no ch�o/Homem de preto, o que � que voc� faz?/Eu fa�o coisas que assustam o satan�s',
       );
    $hinos[int(rand(@hinos))];

}

# frases sobre o cap.nascimento
sub fato {
    my $self = shift;
    my @fatos = (
        'Deus disse que iria fazer o mundo em 7 anos. Capit�o Nascimento disse bem alto: "O senhor � um fanfarr�o, Sr. 01. O senhor tem 7 dias, sr. 01! SETE DIAS!"',
        'Quando vivia no para�so, Capit�o Nascimento for�ou Eva a comer a ma��, dizendo: "Come a porra da ma�� 02! T� com nojinho, 02? Come tudo, porra!"', 
        'A farda do Capit�o Nascimento � preta porque nenhuma outra cor quis ficar perto dele.',
        'O Capeta queria entrar no BOPE, mas o Capit�o Nascimento fez ele desistir apenas dizendo: "666, o senhor � o novo xerife!"',
        'O Capeta vendeu a alma para o Capit�o Nascimento.',
        'Capit�o Nascimento n�o sai de lugar nenhum devendo a ningu�m, sempre p�e na conta do Papa.',
        'Quando Deus disse "Que se fa�a a luz!". Capit�o Nascimento falou "T� de sacanagem, Sr. 01? T� com medinho do escuro, Sr. 01?"',
        'Quando Deus resolveu criar o Universo foi pedir permiss�o ao Capit�o Nascimento e ele respondeu: "� 100%? Ent�o senta o dedo nessa porra!"',
        'A roupa do Super-Homem era preta at� o Capit�o Nascimento dizer: "Tira essa roupa preta que voc� n�o � caveira, voc� � MOLEQUE, ouviu? MO-LE-QUE!"',
        'Capit�o Nascimento trabalhou como negociador da pol�cia. Seu trabalho era ligar para os seq�estradores e dizer: "Pede pra sair, porra!"',
        'Quantos Capit�es Nascimento s�o necess�rios para trocar uma l�mpada? Nenhum, Capit�o Nascimento tamb�m mata no escuro.',
        'Capit�o Nascimento n�o l� livros, ele os coloca no saco at� conseguir toda a informa��o que precisa.',
        'Uma vez ele esque�eu onde deixou as chaves do seu caveir�o. Ele se colocou no saco por 40 segundos e lembrou!',
        'N�o existiam mesmo armas de destrui��o em massa no Iraque. Capit�o Nascimento mora no Rio de Janeiro.',
        'Porque voc� acha que n�o existe terrorismo no Brasil?',
        'Nunca, em nenhuma hipotese, durma na frente do Capit�o Nascimento. Ele vai pedir pra voc� fazer a bondade de segurar a granada.',
        'Em um de seus mandamentos, Deus disse: "N�o Matar�s". O Capit�o Nascimento disse para Deus: "T� de sacanagem, Sr. 01? C� t� de sacanagem comigo, Sr. 01?"',
        'N�o houve impeachment no Governo Collor. O Capit�o Nascimento chegou no Pal�cio do Planalto e disse para o Collor:: "Pede pr� sair!! Pede pr� sair!!"',
        'No dia de S�o Cosme e S�o Dami�o, o Capit�o Nascimento s� pegava saco de doce que tivesse chiclete de Caveira.',
        'Capit�o Nascimento fez com que o Seu Madruga pagasse o aluguel - todos os 14 meses atrasados - e adiantasse mais dois.',
        'Capit�o Nascimento foi ao programa do Faust�o e fez com que ele falasse enquanto o faust�o ficava calado.',
        'Capit�o Nascimento gritou no centro de Buenos Aires que Pel� � o rei do futebol e todos os argentinos concordaram.',
        'Capit�o Nascimento fez um operador de telemarketing dizer: "desculpa, juro que n�o ligo mais".',
        'Capit�o Nascimento resolve o travamento do Windows colocando o PC no saco.',
        'Capit�o Nascimento disse pra Will Smith depois de ver "MIB": O senhor � um fanfarr�o! Homens de Preto � o caralho, s� o BOPE usa preto! Seu viado!',
        'Capit�o Nascimento dorme com um travesseiro debaixo de uma arma.',
        'Capit�o Nascimento sabe exatamente onde est� Carmen Sandiego',
        'Principais causas de morte no Brasil: 1. Ataque do cora��o, 2. Cap. Nascimento, 3.C�ncer; mas a op��o 1 � maior porque a maioria dos bandidos morre do cora��o quando v�em o capit�o.',
       );
    print $fatos[int(rand(@fatos))];
}

42;

__END__

=head1 NAME

Acme::BOPE.pm - Programe armado, cumpadi, e de farda preta.

I<Note: this Acme module lets you program the way the BOPE (brazilian police's special operations squad) policemen talk in the movie "Tropa de Elite". Since its intended audience have to understand portuguese in order to enjoy the module, the rest of the documentation is all in pt_BR. Have fun! Oh, also, this is not to be taken seriously, nor does it expresses the opinion of any of the involved people, nor is oficially linked to the movie.>

B<Esse m�dulo foi feito como uma brincadeira em rela��o ao filme "Tropa de Elite", e n�o deve ser levado � s�rio. Nada do que est� escrito aqui expressa a opini�o dos autores ou qualquer outro envolvido direta ou indiretamente com o mesmo, e n�o h� qualquer tipo de liga��o oficial com o filme. Divirtam-se!>



=head1 VERS�O

Vers�o 0.01



=head1 SINOPSE

   use Acme::Bope;
  
E a partir da� poder� escrever seus programas assim:

   Senhor 01, o senhor eh um "fanfarrao"!
   se o senhor for "moleque" entao pede pra sair "seu viado"! 
   senao senta o dedo nessa porra e bota na conta do Papa!
   vai dar merda, "vai morrer gente...";
   
   O 01 DESISTIU!!!
   
   Os senhores estao fazendo o seu instrutor muito feliz...

que � mais ou menos equivalente a:

   $_01 = "fanfarrao";
   if ($_01 eq "moleque") {
      die "seu viado";
   }
   else {
      print "Caveira, meu capitao!\n" and exit;
      warn "vai morrer gente";

      $_01 = undef;
   }

Voc� ainda pode dar o comando para ouvir seu pelot�o...quer dizer, seu programa... cantar um dos famosos hinos do BOPE:

    Pelot�o, cantar hino!
    # Cachorro latindo/Crian�a chorando/Vagabundo vazando/� o BOPE chegando

Essa vers�o possui 7 hinos cadastrados. Se voc� souber de outro, grite!

E, se voc� tem alguma d�vida sobre o seu capit�o, basta citar o nome dele pra ouvir um dos fatos:

    Capit�o Nascimento?
    # Capit�o Nascimento dorme com um travesseiro debaixo de uma arma.

Essa vers�o possui 28 "fatos" cadastrados. Se voc� souber de outro, grite! E antes que algu�m pergunte, n�o vamos incluir nenhum fato que seja "compartilhado" com Chuck Norris ou Jack Bauer, porque eles s�o MOLEQUES!



=head1 DESCRI��O

Criado na base do morro da Babil�nia, Rio de Janeiro, em plena noite de baile funk, este m�dulo permite que os senhores fa�am incurs�es de programa��o Perl usando apenas jarg�es e linguagens retiradas do famoso filme 'Tropa de Elite' de Jos� Padilha, com estrat�gia e sem fanfarronice. Isso �, se voc�s conseguirem. Sen�o, pede pra sair... e bota na conta do Papa.


=head1 EQUIVAL�NCIAS

Caso ainda seja novo no batalh�o, aqui v�o algumas equival�ncias:

=over 4

=item * I<(print)> - fala, grita

=item * I<(warn "MENSAGEM")> - vai dar merda "MENSAGEM"

=item * I<(system "COMANDO")> - vai pra guerra "COMANDO"

=item * I<(split)> - fatia, fatiou

=item * I<(next)> - passa, passou

=item * I<(last)> - chega!!! p�ra!!!

=item * I<(die)> - pede pra sair

=item * I<(exit)> - desisto, eu desisto, bota na conta do papa

=back

Blocos podem ser escritos de forma simples e direta:

    faz isso aqui:
        ...
    estamos entendidos?
    # ou ainda: os senhores est�o fazendo o seu instrutor muito feliz

� o mesmo que:

    {
        ...
    }

Condicionais s�o feitos assim:

    se EXPRESS�O ent�o
        ...
    sen�o
        ...
    estamos entendidos?

� o mesmo que:

    if (EXPRESS�O) {
        ...
    }
    else {
        ...
    }

Voc� pode tamb�m usar la�os (la�o de homem, nada de ficar botando lacinho nos seus programas!!!):

   para (...) ent�o, fa�a
      ...
   estamos entendidos?

� o mesmo que:

   for (...) {
      ...
   }

ou ainda:

   enquanto (...)
      ...
   estamos entendidos?

� o mesmo que:

   while (...) {
      ...
   }

Lembrando que compara��es podem ser feitas assim:

   ne      nunca ser�o, jamais ser�o, n�o �, n�o ser�, jamais ser�
   not     n�o, nunca, jamais
   eq      ser�, ser�o, for
   ==      vale, valer�


� poss�vel ainda adicionar uma s�rie de palavras adicionais para deixar seu c�digo mais "leg�vel", e impor a ordem entre esses programadores fanfarr�es.

=over 4

=item * o, a, os, as, no, na, nos, nas, do, da, dos, das

=item * ele, ela, eles, elas, dele, dela, deles, delas, desse, dessa, desses, dessas, nesse, nessa, nesses, nessas

=item * seu, sua, seus, suas

=item * eu

=item * com, sem

=item * porra, merda, viado (e pode adicionar quantas interroga��es ou exclama��es quiser depois)

=back 

=head1 MAI�SCULAS E ACENTOS

No linguajar do Bope, nenhuma palavra � sens�vel a caixa. Voc� pode sussurar comandos ou gritar com vagabundos, tudo funciona. Exemplos:



=head1 DIAGN�STICO

Se voc� acha que fez m#$%@ e quer ver o c�digo equivalente em Perl (em vez de simplesmente executar seu programa in�til), passe o par�metro C<DEBUG> para o m�dulo:

   use Acme::BOPE DEBUG => 1;

Quanto tempo voc� precisa pra depurar? 10 minutos???? Fanfarr�o.



=head1 DEPEND�NCIAS

Tu � dependente, merm�o????? Se quiser ver o c�digo de debug cheio de frufru, instala o Perl::Tidy que � 100%.

Ah, e se os senhores n�o tiverem o Filter::Simple instalado, nunca ser�o...



=head1 BUGS

Provavelmente um monte. Se encontrar algum, avisa via RT. Mas sem fanfarrice, estamos entendidos?

(temos ainda que atualizar a documenta��o do m�dulo para incluir vari�veis


=head1 AUTORES

Breno G. de Oliveira C<< <garu at cpan.org> >> e Fernando Corr�a C<< <fco at cpan.org> >>

Esse m�dulo foi feito como uma brincadeira dentro da comunidade Perl sobre o filme Tropa de Elite, na semana de lan�amento do filme. Apresentamos durante o YAPC::Brasil 2007 e o pessoal gostou tanto que encheu a nossa paci�ncia para botarmos no ar. Ta�.


=head1 RECONHECIMENTOS E AGRADECIMENTOS

O c�digo foi fortemente baseado no L<Acme::Lingua::Strine::Perl> do Simon Wistow C<simon [at] twoshortplanks.com>

Agradecimentos especiais ao Bruno C. Buss pelas id�ias e colabora��es, e a todo o pessoal do �nibus que nos levou at� S�o Paulo na v�spera do evento, que nos aturaram madrugada a dentro enquanto termin�vamos o desenvolvimento e corrig�amos alguns bugs.



=head1 VEJA TAMB�M

L<Filter::Simple>, L<Acme::Lingua::Strine::Perl>
L<http://www.tropadeeliteofilme.com.br>



=head1 LICEN�A E COPYRIGHT

Copyright 2008 Breno, Fernando. Todos os direitos reservados.

Este m�dulo � software livre; voc� pode redistribu�-lo e/ou modific�-lo sob os mesmos termos que o Perl em si. Veja L<perlartistic>.



=head1 GARANTIA

Nenhuma. Eu hein...
