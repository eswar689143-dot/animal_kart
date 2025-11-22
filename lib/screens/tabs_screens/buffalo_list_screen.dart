
import 'package:animal_kart_demo2/controllers/buffalo_provider.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../widgets/buffalo_card.dart';

class BuffaloListScreen extends ConsumerWidget {
  const BuffaloListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buffaloAsync = ref.watch(buffaloListProvider);

    return Container(
      color: kScreenBg,
      child: buffaloAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: kPrimaryGreen),
        ),

        error: (err, _) => Center(
          child: Text(
            "Failed to load buffalos\n$err",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        data: (buffalos) => ListView.builder(
          padding: const EdgeInsets.only(bottom: 90, top: 12),
          itemCount: buffalos.length,
          itemBuilder: (context, i) => BuffaloCard(buffalo: buffalos[i]),
        ),
      ),
    );
  }
}
