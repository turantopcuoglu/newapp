import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/storage_provider.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  final VoidCallback onAccepted;

  const DisclaimerScreen({super.key, required this.onAccepted});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen>
    with SingleTickerProviderStateMixin {
  bool _accepted = false;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_accepted) return;
    await ref.read(storageProvider).setDisclaimerAccepted();
    widget.onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B2838), Color(0xFF2D3E50)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.warningAmber.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      size: 40,
                      color: AppTheme.warningAmber,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Yasal Uyarı',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Disclaimer content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withAlpha(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              'Genel Bilgilendirme',
                              'Bu uygulama yalnızca genel bilgilendirme amacıyla '
                                  'hazırlanmış olup, herhangi bir tıbbi teşhis, tedavi '
                                  'veya sağlık danışmanlığı hizmeti sunmamaktadır.',
                            ),
                            const SizedBox(height: 16),
                            _buildSection(
                              'Tıbbi Tavsiye Değildir',
                              'Uygulama içerisinde yer alan beslenme önerileri, tarif '
                                  'tavsiyeleri ve içerik bilgileri herhangi bir tıbbi '
                                  'kaynağa, bilimsel araştırmaya veya sağlık otoritesine '
                                  'dayanmamaktadır. Bu öneriler profesyonel bir diyetisyen, '
                                  'beslenme uzmanı veya doktor tavsiyesi yerine geçmez.',
                            ),
                            const SizedBox(height: 16),
                            _buildSection(
                              'Sorumluluk Reddi',
                              'Uygulamadaki bilgilere dayanarak alınan kararlardan ve '
                                  'bu kararların sonuçlarından uygulama geliştiricileri '
                                  'hiçbir şekilde sorumlu tutulamaz. Sağlık durumunuzla '
                                  'ilgili herhangi bir değişiklik yapmadan önce mutlaka '
                                  'bir sağlık profesyoneline danışınız.',
                            ),
                            const SizedBox(height: 16),
                            _buildSection(
                              'Alerji ve Sağlık Uyarısı',
                              'Gıda alerjiniz, intoleransınız veya herhangi bir sağlık '
                                  'durumunuz varsa, uygulama önerilerini takip etmeden '
                                  'önce mutlaka doktorunuza danışınız. Uygulama, '
                                  'alerjik reaksiyonlar veya sağlık sorunları konusunda '
                                  'sorumluluk kabul etmemektedir.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Checkbox
                  GestureDetector(
                    onTap: () => setState(() => _accepted = !_accepted),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _accepted
                            ? AppTheme.successGreen.withAlpha(25)
                            : Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _accepted
                              ? AppTheme.successGreen.withAlpha(100)
                              : Colors.white.withAlpha(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _accepted
                                  ? AppTheme.successGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _accepted
                                    ? AppTheme.successGreen
                                    : Colors.white54,
                                width: 2,
                              ),
                            ),
                            child: _accepted
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Yukarıdaki yasal uyarıyı okudum ve anladım.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _accepted ? 1.0 : 0.4,
                      child: FilledButton(
                        onPressed: _accepted ? _onContinue : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.accentOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Devam Et',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.warningAmber,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ],
    );
  }
}
