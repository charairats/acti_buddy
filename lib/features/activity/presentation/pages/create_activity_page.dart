import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/core/ui/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class CreateActivityPage extends ConsumerStatefulWidget {
  const CreateActivityPage({super.key});

  @override
  ConsumerState<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends ConsumerState<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = CreateActivityFormData();

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CreateActivityForm(
          formKey: _formKey,
          formData: _formData,
          onSubmit: _handleSubmit,
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_formData.isValid()) {
      _showErrorDialog(_formData.getValidationError());
      return;
    }

    final authUser = ref.read(authStateProvider).asData?.value;
    if (authUser == null) {
      _showErrorDialog('กรุณาเข้าสู่ระบบ');
      return;
    }

    try {
      final activity = _formData.toActivityModel(authUser.uid);
      await ref
          .read(createActivityProvider.notifier)
          .createActivity(
            id: '',
            title: activity.name,
            description: activity.description,
            startDate: activity.startDate,
            endDate: activity.endDate,
            participants: activity.participants,
            categoryId: activity.categoryId,
          );

      if (mounted) {
        const MyToast(
          type: MyToastType.success,
          message: 'Activity created successfully.',
        ).show(context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('เกิดข้อผิดพลาด: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }
}

class CreateActivityForm extends ConsumerWidget {
  const CreateActivityForm({
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final CreateActivityFormData formData;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createActivityAsync = ref.watch(createActivityProvider);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ActivityTitleField(controller: formData.titleController),
          const SizedBox(height: 16),
          ActivityDescriptionField(controller: formData.descriptionController),
          const SizedBox(height: 16),
          ActivityCategorySelector(formData: formData),
          const SizedBox(height: 16),
          ActivityDateTimeSelector(formData: formData),
          const SizedBox(height: 16),
          ActivityParticipantsField(
            controller: formData.participantsController,
          ),
          const SizedBox(height: 24),
          CreateActivityButton(
            isLoading: createActivityAsync.isLoading,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class ActivityTitleField extends StatelessWidget {
  const ActivityTitleField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: TextStyle(
        color: cs.onSurface,
      ),
      decoration: const InputDecoration(
        labelText: 'Activity Title',
        hintText: 'Enter activity title',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the activity title';
        }
        return null;
      },
    );
  }
}

class ActivityDescriptionField extends StatelessWidget {
  const ActivityDescriptionField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter activity description',
      ),
      style: TextStyle(
        color: cs.onSurface,
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the activity description';
        }
        return null;
      },
    );
  }
}

class ActivityCategorySelector extends StatefulWidget {
  const ActivityCategorySelector({
    required this.formData,
    super.key,
  });

  final CreateActivityFormData formData;

  @override
  State<ActivityCategorySelector> createState() =>
      _ActivityCategorySelectorState();
}

class _ActivityCategorySelectorState extends State<ActivityCategorySelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showCategoryBottomSheet(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Category',
          hintText: 'Select a Category',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.formData.selectedCategoryName ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: widget.formData.selectedCategoryName != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryBottomSheet(
        formData: widget.formData,
        onCategorySelected: (categoryId, categoryName) {
          Navigator.of(context).pop();
          if (mounted) {
            setState(() {
              widget.formData.selectedCategoryId = categoryId;
              widget.formData.selectedCategoryName = categoryName;
            });
          }
        },
      ),
    );
  }
}

class CategoryBottomSheet extends ConsumerWidget {
  const CategoryBottomSheet({
    required this.formData,
    required this.onCategorySelected,
    super.key,
  });

  final CreateActivityFormData formData;
  final void Function(String categoryId, String categoryName)
  onCategorySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(browseByCategoriesProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'เลือกหมวดหมู่',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: categoriesAsync.when(
              data: (categories) => ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = formData.selectedCategoryId == category.id;

                  return ListTile(
                    leading: Iconify(
                      iconFromName(category.iconName),
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      category.nameThai,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      category.nameEnglish,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () =>
                        onCategorySelected(category.id, category.nameThai),
                  );
                },
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'เกิดข้อผิดพลาดในการโหลดหมวดหมู่',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () =>
                            ref.refresh(browseByCategoriesProvider),
                        child: const Text('ลองใหม่'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityDateTimeSelector extends StatefulWidget {
  const ActivityDateTimeSelector({
    required this.formData,
    super.key,
  });

  final CreateActivityFormData formData;

  @override
  State<ActivityDateTimeSelector> createState() =>
      _ActivityDateTimeSelectorState();
}

class _ActivityDateTimeSelectorState extends State<ActivityDateTimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateSelector(
          selectedDate: widget.formData.selectedDate,
          onDateSelected: (date) {
            setState(() {
              widget.formData.selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TimeSelector(
                label: 'Select Start Time',
                selectedTime: widget.formData.startTime,
                onTimeSelected: (time) {
                  setState(() {
                    widget.formData.startTime = time;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TimeSelector(
                label: 'Select End Time',
                selectedTime: widget.formData.endTime,
                onTimeSelected: (time) {
                  setState(() {
                    widget.formData.endTime = time;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Date',
          prefixIcon: Icon(
            Icons.calendar_today,
          ),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Choose Date',
          style: TextStyle(
            color: selectedDate != null
                ? cs.onSurface
                : cs.onSurface.withAlpha(100),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      onDateSelected(date);
    }
  }
}

class TimeSelector extends StatelessWidget {
  const TimeSelector({
    required this.label,

    required this.selectedTime,
    required this.onTimeSelected,
    this.hintText,
    super.key,
  });

  final String label;
  final String? hintText;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.access_time),
        ),
        child: Text(
          selectedTime != null
              ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
              : hintText ?? '00:00',
          style: TextStyle(
            color: selectedTime != null
                ? cs.onSurface
                : cs.onSurface.withAlpha(100),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      onTimeSelected(time);
    }
  }
}

class ActivityParticipantsField extends StatelessWidget {
  const ActivityParticipantsField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Number of Participants',
        hintText: 'Enter number of participants',
      ),
      style: TextStyle(
        color: cs.onSurface,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter number of participants';
        }
        final number = int.tryParse(value);
        if (number == null || number <= 0) {
          return 'Please enter a number greater than 0';
        }
        return null;
      },
    );
  }
}

class CreateActivityButton extends StatelessWidget {
  const CreateActivityButton({
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text(
              'Create Activity',
            ),
    );
  }
}

class CreateActivityFormData {
  CreateActivityFormData() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    participantsController = TextEditingController(text: '3');
  }

  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController participantsController;

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedCategoryId;
  String? selectedCategoryName;

  bool isValid() {
    return selectedDate != null && startTime != null && endTime != null;
  }

  String getValidationError() {
    if (selectedDate == null) return 'กรุณาเลือกวันที่';
    if (startTime == null) return 'กรุณาเลือกเวลาเริ่ม';
    if (endTime == null) return 'กรุณาเลือกเวลาสิ้นสุด';
    return '';
  }

  ActivityModel toActivityModel(String creatorId) {
    final startDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final endDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    return ActivityModel(
      id: '',
      name: titleController.text.trim(),
      description: descriptionController.text.trim(),
      startDate: startDateTime,
      endDate: endDateTime,
      createdBy: creatorId,
      participants: int.parse(participantsController.text),
      categoryId: selectedCategoryId,
    );
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    participantsController.dispose();
  }
}
