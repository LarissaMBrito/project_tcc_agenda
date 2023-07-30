import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  final String termsOfUseContent = '''
    Termos de Uso do Aplicativo XYZ

    Bem-vindo(a) ao Aplicativo XYZ. Ao utilizar este aplicativo, você concorda com os seguintes termos e condições:

    1. Uso Responsável: Ao utilizar o Aplicativo XYZ, você concorda em não compartilhar conteúdo ofensivo, difamatório, ou que viole os direitos de terceiros.

    2. Privacidade: Respeitamos a sua privacidade. Ao utilizar o Aplicativo XYZ, podemos coletar e utilizar algumas informações conforme descrito em nossa Política de Privacidade.

    3. Propriedade Intelectual: Todo o conteúdo presente no Aplicativo XYZ, incluindo textos, imagens, logotipos, e outros materiais, são de nossa propriedade ou utilizados com permissão. É proibida a reprodução ou uso não autorizado desse conteúdo.

    4. Modificações nos Termos: Reservamos o direito de modificar estes Termos de Uso a qualquer momento. Quaisquer alterações serão publicadas nesta página.

    Ao continuar a utilizar o Aplicativo XYZ, você concorda em cumprir estes termos. Caso não concorde, por favor, descontinue o uso do aplicativo.

    Data da última atualização: [DATA DE ATUALIZAÇÃO]
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
