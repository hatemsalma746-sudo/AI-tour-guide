import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../utils/app_language.dart';
import 'artifact_data.dart';
import 'artifact_ui.dart';

class AskBastScreen extends StatefulWidget {
  const AskBastScreen({super.key, required this.artifact});

  final Artifact? artifact;

  @override
  State<AskBastScreen> createState() => _AskBastScreenState();
}

class _AskBastScreenState extends State<AskBastScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatEntry> _messages = [];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final question = _messageController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages.add(_ChatEntry(question, isUser: true));
      _messages.add(
        _ChatEntry(
          tourText(
            context,
            'Ask Bast is not connected yet. Your question is saved only in this preview; no AI answer was generated.',
            'خدمة باست غير متصلة حاليًا. سؤالك ظاهر في المعاينة فقط ولم يتم إنشاء إجابة بالذكاء الاصطناعي.',
          ),
          isNotice: true,
        ),
      );
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => TourPageShell(
    title: 'Ask Bast',
    trailing: const LanguagePill(),
    centerTitle: true,
    fullWidth: true,
    resizeToAvoidBottomInset: false,
    maintainBottomViewPadding: true,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final item = widget.artifact;
        if (item == null) {
          return Center(
            child: Text(
              tourText(
                context,
                'Artifact details are unavailable.',
                'تفاصيل القطعة الأثرية غير متاحة.',
              ),
              style: const TextStyle(color: tourMuted),
            ),
          );
        }

        final artifactName = isArabic(context) ? item.arabicName : item.name;
        return SizedBox(
          height: constraints.maxHeight,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (constraints.maxHeight >= 150) ...[
                    RepaintBoundary(
                      child: _ArtifactContext(name: artifactName),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 104),
                      child: _messages.isEmpty
                          ? RepaintBoundary(
                              child: _EmptyConversation(
                                artifactName: artifactName,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) =>
                                  _MessageBubble(message: _messages[index]),
                            ),
                    ),
                  ),
                ],
              ),
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                child: KeyboardFollower(
                  child: RepaintBoundary(
                    child: _MessageComposer(
                      controller: _messageController,
                      onSend: _sendMessage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _ChatEntry {
  const _ChatEntry(this.text, {this.isUser = false, this.isNotice = false});

  final String text;
  final bool isUser;
  final bool isNotice;
}

class _ArtifactContext extends StatelessWidget {
  const _ArtifactContext({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: tourRaised,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xff403b30)),
    ),
    child: Row(
      children: [
        const _BastLogo(size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tourText(context, 'About: $name', 'عن: $name'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: tourCream, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({required this.artifactName});

  final String artifactName;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxHeight < 240 || constraints.maxWidth < 320;
      final veryCompact = constraints.maxHeight < 130;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(compact ? 8 : 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!veryCompact) ...[
                _BastLogo(size: compact ? 38 : 58),
                SizedBox(height: compact ? 7 : 14),
              ],
              Text(
                tourText(context, 'Ask Bast', 'اسأل باست'),
                style: TextStyle(
                  color: tourCream,
                  fontFamily: 'serif',
                  fontSize: compact ? 18 : 21,
                ),
              ),
              if (!veryCompact) ...[
                SizedBox(height: compact ? 4 : 7),
                Text(
                  tourText(
                    context,
                    'Ask a question about $artifactName. Your selected artifact will stay attached to this conversation.',
                    'اسأل عن $artifactName. ستظل القطعة المحددة مرتبطة بالمحادثة.',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: compact ? 2 : null,
                  overflow: compact ? TextOverflow.ellipsis : null,
                  style: TextStyle(
                    color: tourMuted,
                    height: 1.35,
                    fontSize: compact ? 12 : 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

class _BastLogo extends StatelessWidget {
  const _BastLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(size * .05),
    decoration: const BoxDecoration(color: tourRaised, shape: BoxShape.circle),
    child: Image.asset(
      'assets/images/ask_bast_logo_cutout.png',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(Icons.pets_outlined, color: tourGold, size: size * .48),
      ),
    ),
  );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatEntry message;

  @override
  Widget build(BuildContext context) {
    if (message.isNotice) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Icon(Icons.info_outline, color: tourGold, size: 17),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                message.text,
                style: const TextStyle(
                  color: tourMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Align(
      alignment: message.isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .78,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? tourCream : tourRaised,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? tourInk : tourCream,
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _MessageComposer extends StatefulWidget {
  const _MessageComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  State<_MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<_MessageComposer> {
  final _speech = SpeechToText();
  bool _isListening = false;
  bool _recordingErrorDialogOpen = false;
  bool _heardSpeech = false;
  bool _silenceTimeoutTriggered = false;
  Timer? _silenceTimer;
  String _textBeforeListening = '';

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _speech.cancel();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_speech.isListening) {
      _silenceTimer?.cancel();
      _silenceTimeoutTriggered = false;
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final arabic = isArabic(context);
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (status != 'listening' && _heardSpeech) {
            _silenceTimer?.cancel();
          }
          if (mounted) setState(() => _isListening = status == 'listening');
        },
        onError: (error) {
          _silenceTimer?.cancel();
          if (_silenceTimeoutTriggered) return;
          if (!mounted) return;
          setState(() => _isListening = false);
          _showRecordingError(speechError: error.errorMsg);
        },
        options: [SpeechToText.androidNoBluetooth],
      );

      if (!available) {
        final permissionGranted = await _speech.hasPermission;
        _showRecordingError(permissionMissing: !permissionGranted);
        return;
      }

      final localeId = await _localeForLanguage(arabic);
      _textBeforeListening = widget.controller.text.trim();
      _heardSpeech = false;
      _silenceTimeoutTriggered = false;
      await _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.trim().isNotEmpty) {
            _heardSpeech = true;
            _startSilenceTimer();
          }
          _applyTranscript(result.recognizedWords);
        },
        listenOptions: SpeechListenOptions(
          localeId: localeId,
          listenFor: const Duration(seconds: 45),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
        ),
      );
      if (mounted) setState(() => _isListening = _speech.isListening);
      _startSilenceTimer();
    } on MissingPluginException {
      if (mounted) {
        setState(() => _isListening = false);
        _showRecordingError(permissionMissing: false);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isListening = false);
        _showRecordingError(permissionMissing: false);
      }
    }
  }

  void _startSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: _heardSpeech ? 3 : 4), () async {
      if (!mounted) return;
      final showNoSpeechError = !_heardSpeech;
      _silenceTimeoutTriggered = true;
      await _speech.stop();
      if (!mounted) return;
      setState(() => _isListening = false);
      if (showNoSpeechError) {
        _showRecordingError(speechError: 'error_no_match');
      }
    });
  }

  void _applyTranscript(String recognizedWords) {
    final words = recognizedWords.trim();
    if (words.isEmpty) return;
    final text = [
      _textBeforeListening,
      words,
    ].where((part) => part.isNotEmpty).join(' ');
    widget.controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<String?> _localeForLanguage(bool arabic) async {
    final prefix = arabic ? 'ar' : 'en';
    final preferredLocale = arabic ? 'ar-EG' : 'en-US';
    try {
      final locales = await _speech.locales();
      for (final locale in locales) {
        if (locale.localeId.toLowerCase().replaceAll('_', '-') ==
            preferredLocale.toLowerCase()) {
          return locale.localeId;
        }
      }
      for (final locale in locales) {
        final normalized = locale.localeId.toLowerCase().replaceAll('-', '_');
        if (normalized == prefix || normalized.startsWith('${prefix}_')) {
          return locale.localeId;
        }
      }
    } catch (_) {
      // Use an explicit language instead of falling back to the device default.
    }
    return preferredLocale;
  }

  void _showRecordingError({
    bool permissionMissing = true,
    String? speechError,
  }) {
    if (!mounted || _recordingErrorDialogOpen) return;
    _recordingErrorDialogOpen = true;
    final arabic = isArabic(context);
    final errorCode = speechError?.toLowerCase() ?? '';
    final noSpeechWasHeard =
        errorCode.contains('no_match') ||
        errorCode.contains('speech_timeout') ||
        errorCode.contains('no speech') ||
        errorCode.contains('silence');
    final message = speechError != null
        ? noSpeechWasHeard
              ? (arabic
                    ? 'لم يتم رصد أي صوت. يُرجى التحدث بوضوح بعد بدء التسجيل.'
                    : 'No speech was detected. Please speak clearly after recording begins.')
              : (arabic
                    ? 'تعذّر استمرار التسجيل الصوتي. يُرجى المحاولة مرة أخرى.'
                    : 'Voice input could not continue. Please try again.')
        : permissionMissing
        ? (arabic
              ? 'يلزم السماح للتطبيق باستخدام الميكروفون. راجع أذونات التطبيق في إعدادات الجهاز، ثم حاول مرة أخرى.'
              : 'Microphone access is required. Enable the app permission in your device settings, then try again.')
        : (arabic
              ? 'خدمة التعرّف على الكلام غير متاحة على هذا الجهاز. فعّل خدمة تحويل الكلام إلى نص، ثم حاول مرة أخرى.'
              : 'Speech recognition is unavailable on this device. Enable a speech-to-text service, then try again.');

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: tourRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          arabic ? 'الإدخال الصوتي' : 'Voice input',
          style: const TextStyle(color: tourCream),
        ),
        content: Text(
          message,
          textAlign: TextAlign.start,
          style: const TextStyle(color: tourMuted, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              arabic ? 'حسنًا' : 'OK',
              style: const TextStyle(color: tourGold),
            ),
          ),
        ],
      ),
    ).whenComplete(() => _recordingErrorDialogOpen = false);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 6, 6),
    decoration: BoxDecoration(
      color: tourRaised,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xff403b30)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RepaintBoundary(
            child: TextField(
              controller: widget.controller,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              minLines: 1,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              style: const TextStyle(color: tourCream, fontSize: 14),
              cursorColor: tourGold,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: _isListening
                    ? tourText(context, 'Listening…', 'جاري الاستماع…')
                    : tourText(context, 'Ask anything...', 'اسأل أي سؤال...'),
                hintStyle: const TextStyle(color: tourMuted, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(
                  5,
                  9,
                  5,
                  9,
                ),
              ),
              onSubmitted: (_) => widget.onSend(),
            ),
          ),
        ),
        const SizedBox(width: 5),
        IconButton.filled(
          onPressed: _toggleRecording,
          tooltip: _isListening
              ? tourText(context, 'Stop voice input', 'إيقاف التسجيل')
              : tourText(
                  context,
                  'Record a voice question',
                  'سجّل سؤالك صوتيًا',
                ),
          style: IconButton.styleFrom(
            backgroundColor: _isListening ? tourGold : const Color(0xff35312a),
            foregroundColor: _isListening ? tourInk : tourGold,
          ),
          icon: Icon(
            _isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
            size: 20,
          ),
        ),
        const SizedBox(width: 4),
        IconButton.filled(
          onPressed: widget.onSend,
          tooltip: tourText(context, 'Send question', 'إرسال السؤال'),
          style: IconButton.styleFrom(
            backgroundColor: tourGold,
            foregroundColor: tourInk,
          ),
          icon: const Icon(Icons.arrow_upward_rounded, size: 20),
        ),
      ],
    ),
  );
}
