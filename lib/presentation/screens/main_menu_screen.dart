import 'package:chiclet/chiclet.dart';
import 'package:codeleek_core/codeleek_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/utils/AppConstants.dart';
import 'package:puzzle_rush/presentation/widgets/game_button.dart';
import 'package:puzzle_rush/presentation/widgets/main_menu_app_bar.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Make the screen landscape-friendly
    return Scaffold(
      appBar: const MainMenuAppBar(), // Use your new custom AppBar
      extendBodyBehindAppBar: true, // Add this line
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          Image.asset(
            AppConstants.backgroundAsset, // Replace with your image path
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(
              0.7,
            ), // Adjust opacity (0.0 to 1.0) as needed
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Example of a button that uses an SVG icon
                    GameChicletButton(
                      text: AppConstants.playButtonText,
                      onPressed: () => context.push(RoutePaths.levelSelection),
                    ),
                    GameChicletButton(
                      text: AppConstants.dailyPuzzleButtonText,
                      onPressed: () {},
                    ),
                    GameChicletButton(
                      text: AppConstants.shopeButtonText,
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
