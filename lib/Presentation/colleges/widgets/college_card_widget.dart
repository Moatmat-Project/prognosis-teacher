import 'package:flutter/material.dart';
import 'package:moatmat_teacher/Core/resources/colors_r.dart';
import 'package:moatmat_teacher/Core/resources/fonts_r.dart';
import 'package:moatmat_teacher/Features/colleges/domain/entities/college.dart';

class CollegeCardWidget extends StatelessWidget {
  final College college;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollegeCardWidget({
    super.key,
    required this.college,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ColorsResources.borders, width: 0.5),
      ),
      color: ColorsResources.cardBackground,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {}, // Can be used for navigation if needed
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // College Icon or Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: ColorsResources.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: college.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          college.imageUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.account_balance_outlined,
                              color: ColorsResources.primary,
                              size: 30,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.account_balance_outlined,
                        color: ColorsResources.primary,
                        size: 30,
                      ),
              ),

              const SizedBox(height: 12),

              // College Name
              Text(
                college.name,
                style: FontsResources.styleExtraBold(
                  size: 14,
                  color: ColorsResources.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Edit Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.blue,
                      ),
                      tooltip: 'تعديل',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Delete Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 18,
                        color: Colors.red,
                      ),
                      tooltip: 'حذف',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
