import 'package:flutter/material.dart';

dynamic question = [];

final MBBS_questions = [
  {
    'question': 'Pearl is produced from',
    'answer': [
      'Pelecyopods',
      'Cephalopoda',
      'Aplacophora',
      'Monoplacophara',
    ],
    'correct': 'Aplacophora'
  },
  {
    'question': 'Which is associated with exflagellation?',
    'answer': [
      'Microgamete',
      'Macrogamate',
      'Both',
      'None',
    ],
    'correct': 'Microgamete'
  },
  {
    'question': 'In which organ haemozoin is stored?',
    'answer': [
      'Liver',
      'Spleen',
      'Lungs',
      'Kidney',
    ],
    'correct': 'Spleen'
  },
  {
    'question': 'Infective stage of P.vivax is',
    'answer': [
      'Sporozoite',
      'Gametocyte',
      'Trophozoite',
      'Nucleus',
    ],
    'correct': 'Sporozoite'
  },
  {
    'question': 'Which one is the most important character of mammals?',
    'answer': [
      'Diaphragm',
      'Ovoviviparous',
      '4-chambered heart',
      'Kidney',
    ],
    'correct': 'Diaphragm'
  },
  {
    'question': 'What is the function of the Acrosome of sperm?',
    'answer': [
      'Penetration',
      'Dissolving',
      'Killing',
      'Reproduction',
    ],
    'correct': 'Penetration'
  },
  {
    'question': 'Respiration in frogs during hibernation occurs through',
    'answer': [
      'Skin only',
      'Skin + lungs',
      'Skin + lungs + B. cavity',
      'Buccal cavity',
    ],
    'correct': 'Skin only'
  },
  {
    'question': '10. Innominate vein in the frog is formed by the union of',
    'answer': [
      'Internal jugular and subscapular',
      'Only internal jugular',
      'Only scapular',
      'Jugal + scapular',
    ],
    'correct': 'Internal jugular and subscapular'
  },
];

final Nursing_questions = [
  {
    'question': 'What is the main aspect of handwashing?',
    'answer': [
      'Friction',
      'Soap lathering',
      'Gravity',
      'None',
    ],
    'correct': 'Friction'
  },
  {
    'question': 'Normal respiration of adults?',
    'answer': [
      '12/min',
      '16/min',
      '25/min',
      '10/min',
    ],
    'correct': '16/min'
  },
  {
    'question': 'Normal urine output of adult per day is?',
    'answer': [
      '500 ml',
      '750 ml',
      '1500 ml',
      '2000 ml',
    ],
    'correct': '1500 ml '
  },
  {
    'question':
        '4 pint of Normal saline should be provided within 24 hrs, Nurse should regulate I/V at?',
    'answer': [
      '21 drop/min',
      '25 drop/min',
      '31 drop/min',
      '40 drop/min',
    ],
    'correct': '21 drop/min'
  },
  {
    'question': 'Catheterization should be done in Female pts.',
    'answer': [
      'sim’s',
      'supine',
      'dorsal recumbent',
      'Lithotomy',
    ],
    'correct': 'dorsal recumbent'
  },
  {
    'question': 'What should be assessed before giving Digoxin?',
    'answer': [
      'Blood pressure',
      'Pulse rate',
      'Respiration',
      'Temperature',
    ],
    'correct': 'Pulse rate'
  },
  {
    'question':
        'A pts is to receive 2mg of Digoxin. You have 2ml of medicine which contains 4mg/ml. The Nurse should administer',
    'answer': [
      '0.5 ml',
      '1 ml',
      '1.5 ml',
      '2 ml',
    ],
    'correct': '0.5 ml'
  },
  {
    'question':
        'After the birth of a baby, a newborn baby should be wrapped to maintain temperature otherwise heat loss occurs through',
    'answer': [
      'Radiation',
      'Conduction',
      'Convection',
      'Evaporation',
    ],
    'correct': 'Convection'
  },
  {
    'question': 'Rheumatic heart disease is caused by?',
    'answer': [
      'Group A-B hemolytic streptococcus',
      'Streptococcus',
      'Staphylococcus',
      'Kleblessia',
    ],
    'correct': 'Staphylococcus'
  },
];
final BMLT_questions = [
  {
    'question': 'The heart beat of adult is',
    'answer': [
      ' 60-100',
      ' 70',
      ' 70 ',
      ' none',
    ],
    'correct': ' 60-100'
  },
  {
    'question': ' The word coacervate was first used by',
    'answer': [
      ' SL Miller',
      ' Harold Urey',
      ' Sydney',
      ' Oparin',
    ],
    'correct': ' Harold Urey'
  },
  {
    'question': ' The digital formula for hind limb of frog is',
    'answer': [
      ' 23333 ',
      ' 22343',
      ' 03333',
      ' 02233',
    ],
    'correct': ' 22343'
  },
  {
    'question': ' Hyaline cartilage is found in',
    'answer': [
      ' Pubic symphysis',
      ' Pinna',
      ' Suprascapula',
      ' Trachea',
    ],
    'correct': ' Trachea'
  },
  {
    'question': ' In an eye maximum refraction occurs at',
    'answer': [
      ' Lens',
      ' Vitreous humor',
      ' Aqueous humor ',
      ' Cornea',
    ],
    'correct': ' Cornea'
  },
  {
    'question': ' Highest ionization potential is shown by:',
    'answer': [
      ' Alkali metal',
      ' Transitional elements',
      ' Halogens',
      ' Inert gases',
    ],
    'correct': ' Inert gases'
  },
  {
    'question':
        ' Which of the following decreases with the increases in temperature?',
    'answer': [
      ' Molarity',
      ' Molality',
      ' Mole fraction',
      ' Mole number',
    ],
    'correct': ' Molarity'
  },
  {
    'question': ' In dry cell, depolarizer is',
    'answer': [
      ' NH4Cl ',
      ' Zn',
      ' MnO2',
      ' NH3',
    ],
    'correct': ' NH3'
  },
  {
    'question':
        ' The no. of coulombs of electicity required to deposit 0.3 moles of Cu++is',
    'answer': [
      ' 9650 C ',
      ' 2×9650 C',
      ' 4×9650 C',
      ' 6×9650 C',
    ],
    'correct': ' 6×9650 C'
  },
  {
    'question':
        'For the reaction, 2NH3 N2 + 3H2 ; -Q ,the reaction shift right by',
    'answer': [
      ' Decrease in pressure and increase in temp',
      ' Increase in presssure and decrease in temp',
      ' Increase in both temp and pressure',
      ' Decrease in both temp and pressure',
    ],
    'correct': ' Decrease in pressure and increase in temp'
  },
];
final ag_questions = [
  {
    'question': 'Magnetic moment is',
    'answer': [
      ' Scalar',
      ' Vector',
      ' Universal constant',
      ' Tensor',
    ],
    'correct': ' vector'
  },
  {
    'question':
        ' The pendulum of a clock is made of brass. If clock keeps correct time at 200,how many seconds per day will it lose at 350?',
    'answer': [
      ' 3 sec ',
      ' 36 sec',
      ' 24.6 sec ',
      ' 49.25 sec',
    ],
    'correct': ' 24.6 sec'
  },
  {
    'question':
        ' During expansion of a gas if W1 is the work done in isothermal process , W2 is the work done in Isobaric process, and W3 is the work done in adiabatic process then,',
    'answer': [
      ' W3 > W1 > W2',
      ' W2 > W3 > W1',
      ' W1 > W2 > W3',
      ' W1> W3 > W2',
    ],
    'correct': ' W3 > W1 > W2 '
  },
  {
    'question':
        ' Water falls from a height of 420 m. The rise in the temp. of water will be',
    'answer': [
      ' 0.980C exactly ',
      'slightly greater than0.980C',
      ' slightly less than0.980 C',
      ' none',
    ],
    'correct': ' slightly greater than0.980 C'
  },
  {
    'question':
        'What is the induced emf when the flux associated with a coil varies at the rate of 1 weber per min',
    'answer': [
      ' 1V ',
      ' 1/60 V',
      ' 0',
      ' 60 V',
    ],
    'correct': ' 0'
  },
  {
    'question': ' Innermost layer of pollen chamber of angiosperm is',
    'answer': [
      ' Endothecium',
      ' Middle layer',
      ' endothelium ',
      ' Tapetum',
    ],
    'correct': ' tapetum'
  },
  {
    'question': ' Bisexual flower which never open in its life span is',
    'answer': [
      ' Chasmogamous ',
      ' Heterogamous',
      ' Dichogamous ',
      ' Cleistogamous',
    ],
    'correct': ' Cleistogamous'
  },
  {
    'question': ' 3-kingdom system of classification was proposed by',
    'answer': [
      ' Linnaus ',
      ' R.H Whittaker',
      ' Stainier and Von Neil',
      ' Ernest Haeckel',
    ],
    'correct': ' Ernest Haeckel'
  },
  {
    'question': ' On germination,moss spores produce',
    'answer': [
      ' Annulus',
      ' Theca ',
      ' Peristome',
      ' Protonema',
    ],
    'correct': ' Peristome'
  },
  {
    'question': 'Which one is a living fossil?',
    'answer': [
      ' Cycas ',
      ' Pinus',
      ' Dryopteris',
      ' Selaginella',
    ],
    'correct': ' Cycas'
  },
];

class Question extends StatelessWidget {
  var question_var;

  Question(this.question_var);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      child: Text(
        question_var,
        style: TextStyle(
          color: Color.fromARGB(255, 115, 201, 196),
          fontFamily: 'Font1',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
