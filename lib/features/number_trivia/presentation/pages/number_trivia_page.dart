import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_clean_architecture_number_trivia/injection_container.dart';
import 'package:tdd_clean_architecture_number_trivia/main.dart';

import '../widgets/message_display.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({super.key});

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  final controller = TextEditingController();
  String inputString = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager().primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Number Trivia'),
          centerTitle: true,
        ),
        body: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<NumberTriviaBloc>(),
      child: Builder(
        builder: (context) {
          // wrapped with builder, so the context we are about to use knows the NumberTriviaBloc provider
          // else it throws exceptions..
          void getConcreteTrivia() {
            if (inputString.isEmpty) return;
            controller.clear();
            FocusScope.of(context).unfocus();
            BlocProvider.of<NumberTriviaBloc>(context)
                .add(GetTriviaForConcreteNumber(inputString));
          }

          void getRandomTrivia() {
            controller.clear();
            FocusScope.of(context).unfocus();
            BlocProvider.of<NumberTriviaBloc>(context)
                .add(GetTriviaForRandomNumber());
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // top half
                  BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                      builder: (context, state) {
                    if (state is NumberTriviaInitial) {
                      return const MessageDisplay(
                        message: 'Start searching',
                      );
                    } else if (state is Loading) {
                      return const MessageDisplay(
                        message: 'Loading',
                        isLoading: true,
                      );
                    } else if (state is Loaded) {
                      return MessageDisplay(
                        message: state.trivia.text,
                        number: state.trivia.number,
                      );
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message);
                    }
                    return const CircularProgressIndicator();
                  }),

                  const SizedBox(height: 30.0),

                  // bottom half
                  Column(
                    children: [
                      TextField(
                        controller: controller,
                        onChanged: (value) {
                          inputString = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: greenColor, width: 2),
                          ),
                          hintText: 'Input a number',
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: getConcreteTrivia,
                                child: const Text('Search Trivia')),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: getRandomTrivia,
                                child: const Text('Get Random Trivia')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
