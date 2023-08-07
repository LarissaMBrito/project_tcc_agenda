import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  final String termsOfUseContent = '''
    Termo de Coleta de Dados e Consentimento

Este Termo de Coleta de Dados e Consentimento ("Termo") tem como objetivo informar aos usuários sobre a coleta e o uso de dados pessoais pelo aplicativo de agendamento de consultas médicas ("Aplicativo"). Ao utilizar o Aplicativo, você ("Usuário") concorda com os termos estabelecidos neste documento.

Dados Coletados
O Aplicativo coleta os seguintes dados pessoais do Usuário:

Nome completo
E-mail
Telefone
CPF (Cadastro de Pessoa Física)
Essas informações são necessárias para o correto funcionamento do Aplicativo e para possibilitar o agendamento de consultas médicas de forma eficiente e segura.

Finalidade da Coleta de Dados
Os dados pessoais fornecidos serão utilizados para os seguintes propósitos:

Facilitar o agendamento de consultas médicas;
Comunicar-se com o Usuário sobre os detalhes da consulta, como horário, local e confirmações;
Enviar notificações relevantes relacionadas ao agendamento e ao uso do Aplicativo;
Garantir a segurança e a identificação adequada dos Usuários;
Cumprir obrigações legais e regulatórias.
Compartilhamento de Dados
O Aplicativo poderá compartilhar os dados pessoais do Usuário com terceiros, exclusivamente com o propósito de possibilitar o agendamento de consultas médicas, incluindo médicos, clínicas ou estabelecimentos de saúde que ofereçam serviços médicos através do Aplicativo. O compartilhamento será feito de forma restrita e limitada ao necessário para a execução dos serviços solicitados pelo Usuário.

Segurança dos Dados
O Aplicativo adotará medidas técnicas e organizacionais para proteger os dados pessoais do Usuário contra acesso não autorizado, uso indevido, perda ou divulgação não autorizada.

Armazenamento dos Dados
Os dados pessoais do Usuário serão armazenados pelo Aplicativo durante o tempo necessário para cumprir os propósitos mencionados neste Termo, ou conforme exigido por lei. Após esse período, os dados serão anonimizados ou eliminados de forma segura.

Direitos do Usuário
O Usuário tem o direito de solicitar acesso, retificação, exclusão ou portabilidade dos seus dados pessoais. Para exercer esses direitos ou para esclarecer qualquer dúvida relacionada a esta política, o Usuário pode entrar em contato através dos canais de suporte fornecidos no Aplicativo.

Consentimento do Usuário
Ao utilizar o Aplicativo e fornecer seus dados pessoais, o Usuário consente de forma livre, informada e inequívoca com os termos desta política de privacidade e com a coleta e uso de seus dados conforme descrito neste Termo.

Alterações na Política
Esta política de privacidade poderá ser atualizada periodicamente. O Usuário será notificado sobre quaisquer mudanças relevantes, e a versão mais atualizada estará sempre disponível no Aplicativo.

Ao clicar em "Aceito" ou ao prosseguir com o uso do Aplicativo, o Usuário declara estar ciente e concorda com os termos deste Termo de Coleta de Dados e Consentimento.
    ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termos de uso'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(termsOfUseContent),
          ],
        ),
      ),
    );
  }
}
