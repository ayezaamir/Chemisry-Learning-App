import 'package:flutter/material.dart';
import 'QuizResultScreen.dart';
import 'dart:math';

class QuizWelcomeScreen extends StatelessWidget {
  final String userName;

  QuizWelcomeScreen({required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 80),
          child: Text('Quiz',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/mainimg.png",
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to the Chemistry Quiz!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Image.asset("assets/images/chemquiz.png", height: 200),
              SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006EE9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen(userName: userName,)),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Start  Quiz',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF006EE9),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String userName;

  QuizScreen({required this.userName});
  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOption;
  late List<QuizQuestion> randomizedQuestions;

  final List<QuizQuestion> _allQuestions = [
    QuizQuestion(
      question: "An example of an ionic compound is:",
      options: ["H₂", "CH₄", "N₂", "NaCl"],
      correctIndex: 3,
    ),
    QuizQuestion(
      question: "Interaction between highly electron-deficient hydrogen and a highly electronegative atom is called:",
      options: ["Covalent bond", "Ionic bond", "Hydrogen bond", "Metallic bond"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Two fluorine atoms share one electron each in their outermost shell to achieve the electronic configuration of:",
      options: ["Xe", "Ar", "Kr", "Ne"],
      correctIndex: 3,
    ),
    QuizQuestion(
      question: "Number of electrons lost by atoms of group IIIA equals:",
      options: ["1", "2", "3", "4"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "An atom that loses two electrons from its outer shell to form an ion is called:",
      options: ["Oxygen", "Potassium", "Magnesium", "Carbon"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "In NaCl crystal lattice, each Na+ ion is surrounded by:",
      options: ["6 Cl⁻ ions", "6 Na⁺ ions", "8 Cl⁻ ions", "12 Cl⁻ ions"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "At room temperature most of ionic compounds are:",
      options: ["amorphous solids", "crystalline solids", "liquids", "gases"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "The tendency of atoms to acquire eight electrons in their valence shell is called:",
      options: ["Octet rule", "Duplet rule", "Triplet rule", "None of the above"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "When one atom forms a cation by losing an electron and another forms an anion by accepting that electron, the bond formed between them is:",
      options: ["Covalent bond", "Ionic bond", "Coordinate covalent bond", "Hydrogen bond"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Noble gases are stable because they contain:",
      options: ["4 electrons", "6 electrons", "8 electrons", "10 electrons"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "A bond that involves three shared electron pairs is a:",
      options: ["Double covalent bond", "Single covalent bond", "Triple covalent bond", "None of the above"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Covalent bonds involve:",
      options: ["Transfer of electrons", "Sharing of electrons", "Loss of electrons", "Gain of electrons"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "The type of bond present in water (H₂O) is:",
      options: ["Ionic bond", "Covalent bond", "Metallic bond", "Hydrogen bond"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which of the following is an example of a covalent compound?",
      options: ["NaCl", "KBr", "H₂O", "MgO"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "Which type of bond is the strongest?",
      options: ["Ionic bond", "Covalent bond", "Hydrogen bond", "Metallic bond"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "The correct Lewis structure for methane (CH₄) includes:",
      options: ["Four single bonds", "Two single bonds and one double bond", "Two double bonds", "One triple bond and one single bond"],
      correctIndex: 0,
    ),
    QuizQuestion(
      question: "A polar covalent bond is formed when:",
      options: ["Electrons are equally shared", "Electrons are transferred", "One atom has a stronger attraction", "Both atoms lose electrons"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "What type of bond holds sodium and chloride ions together in NaCl?",
      options: ["Covalent bond", "Ionic bond", "Hydrogen bond", "Metallic bond"],
      correctIndex: 1,
    ),
    QuizQuestion(
      question: "Which molecule has a nonpolar covalent bond?",
      options: ["H₂O", "NH₃", "O₂", "HCl"],
      correctIndex: 2,
    ),
    QuizQuestion(
      question: "The bond formed by the electrostatic attraction between positively and negatively charged ions is called:",
      options: ["Ionic bond", "Covalent bond", "Metallic bond", "Hydrogen bond"],
      correctIndex: 0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    randomizedQuestions = List.from(_allQuestions)..shuffle(Random());
  }

  void _submitAnswer() {
    if (_selectedOption == null) return;

    if (_selectedOption == randomizedQuestions[_currentQuestionIndex].correctIndex) {
      _score++;
    }

    if (_currentQuestionIndex < randomizedQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            userName: widget.userName,
            score: _score,
            total: randomizedQuestions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = randomizedQuestions[_currentQuestionIndex];
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/mainimg.png",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${randomizedQuestions.length}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 16),
                Text(
                  current.question,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: 16),
                Column(
                  children: List.generate(current.options.length, (index) {
                    return RadioListTile<int>(
                      title: Text(
                        current.options[index],
                        style: TextStyle(color: Colors.black),
                      ),
                      value: index,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    );
                  }),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006EE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: _submitAnswer,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF006EE9),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
