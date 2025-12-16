import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroTimer extends StatefulWidget {
  final String Function(String) translate;
  final Color themeColor;
  final bool isDarkMode;

  const PomodoroTimer({
    super.key,
    required this.translate,
    required this.themeColor,
    required this.isDarkMode,
  });

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  static const int workDuration = 25 * 60; // 25 minutes
  static const int shortBreakDuration = 5 * 60; // 5 minutes
  static const int longBreakDuration = 15 * 60; // 15 minutes

  int _timeRemaining = workDuration;
  bool _isRunning = false;
  bool _isWorkSession = true;
  int _completedSessions = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timeRemaining = _isWorkSession ? workDuration : _getBreakDuration();
    });
  }

  int _getBreakDuration() {
    // Long break after 4 work sessions
    return (_completedSessions > 0 && _completedSessions % 4 == 0)
        ? longBreakDuration
        : shortBreakDuration;
  }

  void _onTimerComplete() {
    if (_isWorkSession) {
      setState(() {
        _completedSessions++;
        _isWorkSession = false;
        _timeRemaining = _getBreakDuration();
      });
      _showCompletionDialog();
    } else {
      setState(() {
        _isWorkSession = true;
        _timeRemaining = workDuration;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: widget.themeColor),
            const SizedBox(width: 10),
            Text(
              widget.translate('pomodoro_complete'),
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          '${widget.translate('pomodoro_break')}: ${_formatTime(_getBreakDuration())}',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            child: Text(
              widget.translate('pomodoro_start'),
              style: TextStyle(color: widget.themeColor),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _isWorkSession
        ? 1 - (_timeRemaining / workDuration)
        : 1 - (_timeRemaining / _getBreakDuration());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Session indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isWorkSession
                  ? widget.themeColor.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isWorkSession ? Icons.work : Icons.coffee,
                  size: 18,
                  color: _isWorkSession ? widget.themeColor : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  _isWorkSession
                      ? widget.translate('pomodoro_work')
                      : widget.translate('pomodoro_break'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isWorkSession ? widget.themeColor : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Timer display
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: widget.isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isWorkSession ? widget.themeColor : Colors.green,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _formatTime(_timeRemaining),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.translate('pomodoro')}: $_completedSessions',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.isDarkMode
                          ? Colors.white54
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset button
              IconButton(
                onPressed: _resetTimer,
                icon: Icon(
                  Icons.refresh,
                  color: widget.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
                iconSize: 28,
              ),
              const SizedBox(width: 20),
              // Play/Pause button
              GestureDetector(
                onTap: _isRunning ? _pauseTimer : _startTimer,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _isWorkSession ? widget.themeColor : Colors.green,
                        (_isWorkSession ? widget.themeColor : Colors.green)
                            .withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isWorkSession ? widget.themeColor : Colors.green)
                            .withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Skip button
              IconButton(
                onPressed: () {
                  _timer?.cancel();
                  _onTimerComplete();
                },
                icon: Icon(
                  Icons.skip_next,
                  color: widget.isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
