import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

void main() => runApp(const MyApp());

// ==================== مدل داده ====================
class PestInfo {
  final String name;
  final String commonName;
  final String order;
  final String distribution;
  final String hosts;
  final String damage;
  final String symptoms;
  final String controlMethods;
  final String quarantineStatus;

  PestInfo({
    required this.name,
    required this.commonName,
    required this.order,
    required this.distribution,
    required this.hosts,
    required this.damage,
    required this.symptoms,
    required this.controlMethods,
    required this.quarantineStatus,
  });
}

// ==================== دیتابیس آفات ====================
class PestDatabase {
  static final Map<int, PestInfo> pests = {
    0: PestInfo(name:'Adoxophyes orana',commonName:'کرم برگ‌پیچ درختان میوه',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا و آسیا',hosts:'درختان میوه',damage:'خسارت به برگ و میوه',symptoms:'برگ‌های پیچیده',controlMethods:'تله فرمونی و Bt',quarantineStatus:'آفت قرنطینه‌ای'),
    1: PestInfo(name:'Amrasca biguttula',commonName:'زنجرک پنبه',order:'Hemiptera - نیم‌بالان',distribution:'آسیا',hosts:'پنبه و سبزیجات',damage:'مکیدن شیره گیاهی',symptoms:'زردی برگ',controlMethods:'کنترل بیولوژیک و سموم',quarantineStatus:'آفت مهم کشاورزی'),
    2: PestInfo(name:'Anastrepha ludens',commonName:'مگس میوه مکزیکی',order:'Diptera - دوبالان',distribution:'آمریکای مرکزی',hosts:'مرکبات و انبه',damage:'پوسیدگی میوه',symptoms:'سوراخ تخم‌ریزی',controlMethods:'تله و طعمه‌پاشی',quarantineStatus:'آفت قرنطینه‌ای'),
    3: PestInfo(name:'Anastrepha suspensa',commonName:'مگس میوه کارائیب',order:'Diptera - دوبالان',distribution:'کارائیب',hosts:'میوه‌های گرمسیری',damage:'خسارت به میوه',symptoms:'ریزش میوه',controlMethods:'تله‌گذاری',quarantineStatus:'آفت قرنطینه‌ای'),
    4: PestInfo(name:'Anoplophora chinensis',commonName:'سوسک شاخک‌بلند مرکبات',order:'Coleoptera - قاب‌بالان',distribution:'شرق آسیا',hosts:'مرکبات و درختان زینتی',damage:'خسارت به تنه',symptoms:'سوراخ خروجی',controlMethods:'حذف درخت آلوده',quarantineStatus:'قرنطینه‌ای'),
    5: PestInfo(name:'Anoplophora glabripennis',commonName:'سوسک شاخک‌بلند آسیایی',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'درختان پهن‌برگ',damage:'مرگ درخت',symptoms:'خشکیدگی شاخه',controlMethods:'ریشه‌کنی',quarantineStatus:'قرنطینه‌ای'),
    6: PestInfo(name:'Bactrocera cucurbitae',commonName:'مگس جالیز',order:'Diptera - دوبالان',distribution:'گرمسیری',hosts:'کدوییان',damage:'خسارت به میوه',symptoms:'پوسیدگی',controlMethods:'تله فرمونی',quarantineStatus:'قرنطینه‌ای'),
    7: PestInfo(name:'Bactrocera dorsalis',commonName:'مگس میوه شرقی',order:'Diptera - دوبالان',distribution:'آسیا و آفریقا',hosts:'بیش از 300 گونه گیاهی',damage:'پوسیدگی میوه',symptoms:'لکه و سوراخ',controlMethods:'متیل اوژنول',quarantineStatus:'قرنطینه‌ای'),
    8: PestInfo(name:'Bactrocera papayae',commonName:'مگس میوه پاپایا',order:'Diptera - دوبالان',distribution:'جنوب شرق آسیا',hosts:'پاپایا و انبه',damage:'خسارت میوه',symptoms:'نرم شدن میوه',controlMethods:'تله و طعمه',quarantineStatus:'قرنطینه‌ای'),
    9: PestInfo(name:'Bactrocera tryoni',commonName:'مگس میوه کوئینزلند',order:'Diptera - دوبالان',distribution:'استرالیا',hosts:'انواع میوه',damage:'خسارت میوه',symptoms:'ریزش زودرس',controlMethods:'تله‌گذاری',quarantineStatus:'قرنطینه‌ای'),
    10: PestInfo(name:'Blitopertha orientalis',commonName:'سوسک شرقی',order:'Coleoptera - قاب‌بالان',distribution:'آسیا',hosts:'چمن و ریشه گیاهان',damage:'تغذیه از ریشه',symptoms:'زردی گیاه',controlMethods:'مدیریت خاک',quarantineStatus:'آفت مهم'),
    11: PestInfo(name:'Cacoecimorpha pronubana',commonName:'برگ‌پیچ مدیترانه‌ای',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'گیاهان زراعی و زینتی',damage:'خسارت برگی',symptoms:'برگ پیچیده',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    12: PestInfo(name:'Ceratitis cosyra',commonName:'مگس انبه',order:'Diptera - دوبالان',distribution:'آفریقا',hosts:'انبه',damage:'پوسیدگی میوه',symptoms:'سوراخ میوه',controlMethods:'تله و طعمه',quarantineStatus:'قرنطینه‌ای'),
    13: PestInfo(name:'Cicadulina mbila',commonName:'زنجرک ذرت',order:'Hemiptera - نیم‌بالان',distribution:'آفریقا',hosts:'ذرت',damage:'انتقال بیماری',symptoms:'کوتولگی',controlMethods:'کنترل ناقل',quarantineStatus:'آفت مهم'),
    14: PestInfo(name:'Conotrachelus nenuphar',commonName:'سرخرطومی آلو',order:'Coleoptera - قاب‌بالان',distribution:'آمریکای شمالی',hosts:'آلو و هلو',damage:'خسارت میوه',symptoms:'زخم هلالی',controlMethods:'سم‌پاشی',quarantineStatus:'قرنطینه‌ای'),
    15: PestInfo(name:'Cosmopolites sordidus',commonName:'سوسک موز',order:'Coleoptera - قاب‌بالان',distribution:'مناطق موزکاری',hosts:'موز',damage:'خسارت ریزوم',symptoms:'ضعف بوته',controlMethods:'بهداشت مزرعه',quarantineStatus:'آفت مهم'),
    16: PestInfo(name:'Cryptoblabes gnidiella',commonName:'بید خرما',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'خرما و انگور',damage:'خسارت خوشه',symptoms:'تار و فضولات',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    17: PestInfo(name:'Dendroctonus micans',commonName:'سوسک پوست‌خوار صنوبر',order:'Coleoptera - قاب‌بالان',distribution:'اروپا و آسیا',hosts:'کاج و صنوبر',damage:'مرگ درخت',symptoms:'رزین و سوراخ',controlMethods:'کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    18: PestInfo(name:'Diatraea saccharalis',commonName:'ساقه‌خوار نیشکر',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکا',hosts:'نیشکر و ذرت',damage:'دالان در ساقه',symptoms:'شکستگی ساقه',controlMethods:'زنبور پارازیتوئید',quarantineStatus:'آفت مهم'),
    19: PestInfo(name:'Earias fabia',commonName:'کرم غوزه بامیه',order:'Lepidoptera - پروانه‌سانان',distribution:'آسیا',hosts:'بامیه و پنبه',damage:'خسارت میوه',symptoms:'سوراخ و ریزش',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    20: PestInfo(name:'Epiphyas postvittana',commonName:'برگ‌پیچ استرالیایی',order:'Lepidoptera - پروانه‌سانان',distribution:'استرالیا',hosts:'بیش از 500 گیاه',damage:'خسارت برگ و میوه',symptoms:'پیچیدگی برگ',controlMethods:'Bt',quarantineStatus:'قرنطینه‌ای'),
    21: PestInfo(name:'Epitrix tuberis',commonName:'کک سیب‌زمینی',order:'Coleoptera - قاب‌بالان',distribution:'آمریکا',hosts:'سیب‌زمینی',damage:'خسارت غده',symptoms:'سوراخ سطحی',controlMethods:'مدیریت زراعی',quarantineStatus:'قرنطینه‌ای'),
    22: PestInfo(name:'Eudocima fullonia',commonName:'شب‌پره میوه‌خوار',order:'Lepidoptera - پروانه‌سانان',distribution:'گرمسیری',hosts:'مرکبات و انبه',damage:'مکیدن شیره میوه',symptoms:'زخم میوه',controlMethods:'تله نوری',quarantineStatus:'آفت مهم'),
    23: PestInfo(name:'Gilpinia hercyniae',commonName:'اره‌مگس صنوبر',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا',hosts:'صنوبر',damage:'برگ‌خواری',symptoms:'ریزش سوزن‌ها',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت جنگلی'),
    24: PestInfo(name:'Gonipterus scutellatus',commonName:'سرخرطومی اکالیپتوس',order:'Coleoptera - قاب‌بالان',distribution:'استرالیا',hosts:'اکالیپتوس',damage:'برگ‌خواری',symptoms:'کاهش رشد',controlMethods:'زنبور پارازیتوئید',quarantineStatus:'قرنطینه‌ای'),
    25: PestInfo(name:'Helicoverpa zea',commonName:'کرم بلال ذرت',order:'Lepidoptera - پروانه‌سانان',distribution:'قاره آمریکا',hosts:'ذرت و پنبه',damage:'خسارت زایشی',symptoms:'سوراخ بلال',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    26: PestInfo(name:'Liriomyza huidobrensis',commonName:'مینوز برگ',order:'Diptera - دوبالان',distribution:'جهان‌گستر',hosts:'سبزیجات و گل‌ها',damage:'مینوز برگ',symptoms:'دالان سفید',controlMethods:'کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    27: PestInfo(name:'Lymantria monacha',commonName:'پروانه راهبه',order:'Lepidoptera - پروانه‌سانان',distribution:'اروپا و آسیا',hosts:'درختان جنگلی',damage:'برگ‌خواری شدید',symptoms:'لخت شدن درخت',controlMethods:'Bt',quarantineStatus:'قرنطینه‌ای'),
    28: PestInfo(name:'Monochamus alternatus',commonName:'سوسک کاج ژاپنی',order:'Coleoptera - قاب‌بالان',distribution:'شرق آسیا',hosts:'کاج',damage:'ناقل نماتد کاج',symptoms:'خشکیدگی',controlMethods:'قطع درخت آلوده',quarantineStatus:'قرنطینه‌ای'),
    29: PestInfo(name:'Monochamus urussovi',commonName:'سوسک شاخک‌بلند مخروطیان',order:'Coleoptera - قاب‌بالان',distribution:'روسیه و آسیا',hosts:'مخروطیان',damage:'خسارت چوب',symptoms:'سوراخ تنه',controlMethods:'مدیریت جنگل',quarantineStatus:'آفت جنگلی'),
    30: PestInfo(name:'Perkinsiella saccharicida',commonName:'زنجرک نیشکر',order:'Hemiptera - نیم‌بالان',distribution:'اقیانوسیه',hosts:'نیشکر',damage:'انتقال ویروس',symptoms:'ضعف گیاه',controlMethods:'کنترل ناقل',quarantineStatus:'آفت مهم'),
    31: PestInfo(name:'Pissodes castaneus',commonName:'سرخرطومی کاج',order:'Coleoptera - قاب‌بالان',distribution:'اروپا',hosts:'کاج',damage:'خسارت ساقه',symptoms:'خشکیدگی',controlMethods:'بهداشت جنگل',quarantineStatus:'قرنطینه‌ای'),
    32: PestInfo(name:'Popillia japonica',commonName:'سوسک ژاپنی',order:'Coleoptera - قاب‌بالان',distribution:'ژاپن و آمریکا',hosts:'بیش از 300 گیاه',damage:'برگ‌خواری',symptoms:'اسکلت برگ',controlMethods:'تله و کنترل بیولوژیک',quarantineStatus:'قرنطینه‌ای'),
    33: PestInfo(name:'Prays oleae',commonName:'بید زیتون',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'زیتون',damage:'خسارت گل و میوه',symptoms:'ریزش میوه',controlMethods:'تله فرمونی',quarantineStatus:'آفت مهم'),
    34: PestInfo(name:'Pristiphora abietina',commonName:'اره‌مگس صنوبر نروژی',order:'Hymenoptera - بال‌غشاییان',distribution:'اروپا',hosts:'صنوبر',damage:'برگ‌خواری',symptoms:'قهوه‌ای شدن سوزن',controlMethods:'کنترل بیولوژیک',quarantineStatus:'آفت جنگلی'),
    35: PestInfo(name:'Spodoptera eridania',commonName:'کرم برگ‌خوار جنوبی',order:'Lepidoptera - پروانه‌سانان',distribution:'آمریکا',hosts:'سبزیجات',damage:'برگ‌خواری',symptoms:'سوراخ برگ',controlMethods:'Bt',quarantineStatus:'آفت مهم'),
    36: PestInfo(name:'Spodoptera frugiperda',commonName:'کرم برگخوار پاییزه',order:'Lepidoptera - پروانه‌سانان',distribution:'جهان‌گستر',hosts:'ذرت و غلات',damage:'خسارت شدید مزرعه',symptoms:'پارگی برگ',controlMethods:'IPM و Bt',quarantineStatus:'قرنطینه‌ای'),
    37: PestInfo(name:'Sternochetus mangiferae',commonName:'سرخرطومی هسته انبه',order:'Coleoptera - قاب‌بالان',distribution:'مناطق انبه‌خیز',hosts:'انبه',damage:'خسارت هسته',symptoms:'کاهش کیفیت',controlMethods:'قرنطینه و بهداشت',quarantineStatus:'قرنطینه‌ای'),
    38: PestInfo(name:'Thaumatopoea pityocampa',commonName:'پروانه ابریشم‌باف کاج',order:'Lepidoptera - پروانه‌سانان',distribution:'مدیترانه',hosts:'کاج',damage:'برگ‌خواری',symptoms:'لانه‌های ابریشمی',controlMethods:'Bt',quarantineStatus:'آفت جنگلی'),
  };

  static PestInfo? getPestByIndex(int index) {
    return pests[index];
  }
}

// ==================== نتایج تشخیص ====================
class ClassificationResult {
  final PestInfo pestInfo;
  final double confidence;
  final int rank;

  ClassificationResult({
    required this.pestInfo,
    required this.confidence,
    required this.rank,
  });
}

class TopPredictions {
  final List<ClassificationResult> predictions;
  TopPredictions(this.predictions);
  ClassificationResult? get top => predictions.isNotEmpty ? predictions.first : null;
}

// ==================== سرویس تشخیص ====================
class ClassifierService {
  Interpreter? _interpreter;
  final int _inputSize = 224;
  final int _numClasses = 39;

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/QU_Pests_39Epochs_YOLO26n_float32.tflite');
    } catch (e) {
      throw Exception('خطا در بارگذاری مدل: $e');
    }
  }

  Future<TopPredictions?> classifyImage(File imageFile) async {
    if (_interpreter == null) return null;

    try {
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) return null;

      img.Image resized = img.copyResize(image, width: _inputSize, height: _inputSize);

      var input = List.filled(1 * _inputSize * _inputSize * 3, 0.0)
          .reshape([1, _inputSize, _inputSize, 3]);
      for (int y = 0; y < _inputSize; y++) {
        for (int x = 0; x < _inputSize; x++) {
          var pixel = resized.getPixel(x, y);
          input[0][y][x][0] = pixel.r / 255.0;
          input[0][y][x][1] = pixel.g / 255.0;
          input[0][y][x][2] = pixel.b / 255.0;
        }
      }

      var output = List.filled(1 * _numClasses, 0.0).reshape([1, _numClasses]);
      _interpreter!.run(input, output);

      List<MapEntry<int, double>> allPredictions = [];
      for (int i = 0; i < _numClasses; i++) {
        allPredictions.add(MapEntry(i, output[0][i]));
      }
      allPredictions.sort((a, b) => b.value.compareTo(a.value));

      List<ClassificationResult> top3 = [];
      for (int i = 0; i < 3 && i < allPredictions.length; i++) {
        int index = allPredictions[i].key;
        double confidence = allPredictions[i].value;
        PestInfo? pest = PestDatabase.getPestByIndex(index);
        if (pest != null) {
          top3.add(ClassificationResult(
            pestInfo: pest,
            confidence: confidence,
            rank: i + 1,
          ));
        }
      }

      return TopPredictions(top3);
    } catch (e) {
      throw Exception('خطا در پردازش: $e');
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}

// ==================== اپلیکیشن ====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تشخیص حشرات قرنطینه',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==================== صفحه اصلی ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClassifierService _classifier = ClassifierService();
  File? _imageFile;
  bool _isProcessing = false;
  bool _modelLoaded = false;
  TopPredictions? _predictions;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _classifier.loadModel();
      setState(() => _modelLoaded = true);
    } catch (e) {
      _showError('خطا در بارگذاری مدل: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!_modelLoaded) {
      _showError('مدل هنوز آماده نیست. لطفاً صبر کنید.');
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source, imageQuality: 95);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isProcessing = true;
        _predictions = null;
      });

      try {
        final result = await _classifier.classifyImage(_imageFile!);
        if (!mounted) return;

        if (result != null && result.top != null) {
          setState(() {
            _predictions = result;
            _isProcessing = false;
          });
        } else {
          _showError('تشخیص ممکن نبود. لطفاً تصویر بهتری انتخاب کنید.');
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ✅ هدر: بخش تحقیقات جنگل و مرتع
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'بخش تحقیقات جنگل و مرتع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // عنوان فرعی
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'تشخیص حشرات قرنطینه‌ای',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

              // محتوای اصلی
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // نمایش تصویر
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _imageFile != null
                                ? Image.file(_imageFile!, height: 280, width: double.infinity, fit: BoxFit.cover)
                                : Container(
                                    height: 280,
                                    color: Colors.green.shade50,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.bug_report_outlined, size: 100, color: Colors.green.shade300),
                                        const SizedBox(height: 16),
                                        Text('تصویر حشره را انتخاب کنید', style: TextStyle(color: Colors.green.shade700)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // دکمه‌ها
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isProcessing || !_modelLoaded ? null : () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt, size: 20),
                              label: const Text('دوربین'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _isProcessing || !_modelLoaded ? null : () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library, size: 20),
                              label: const Text('گالری'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Loading
                        if (_isProcessing) ...[
                          const CircularProgressIndicator(color: Colors.green),
                          const SizedBox(height: 12),
                          const Text('در حال تحلیل تصویر...', style: TextStyle(fontSize: 16, color: Colors.green)),
                          const SizedBox(height: 20),
                        ],

                        // ✅ نمایش نتایج (3 تشخیص برتر)
                        if (_predictions != null && !_isProcessing) ...[
                          // تشخیص اول - با جزئیات کامل
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade400, Colors.green.shade600],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.verified, color: Colors.white, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      'تشخیص اول (${(_predictions!.top!.confidence * 100).toStringAsFixed(1)}%)',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _predictions!.top!.pestInfo.commonName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _predictions!.top!.pestInfo.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white70,
                                  ),
                                ),
                                const Divider(color: Colors.white30, height: 24),
                                _buildDetailRow(Icons.category, 'راسته', _predictions!.top!.pestInfo.order),
                                _buildDetailRow(Icons.public, 'پراکنش', _predictions!.top!.pestInfo.distribution),
                                _buildDetailRow(Icons.eco, 'میزبان‌ها', _predictions!.top!.pestInfo.hosts),
                                _buildDetailRow(Icons.warning_amber, 'خسارت', _predictions!.top!.pestInfo.damage),
                                _buildDetailRow(Icons.visibility, 'علائم', _predictions!.top!.pestInfo.symptoms),
                                _buildDetailRow(Icons.shield, 'کنترل', _predictions!.top!.pestInfo.controlMethods),
                                _buildDetailRow(Icons.gavel, 'قرنطینه', _predictions!.top!.pestInfo.quarantineStatus),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // تشخیص دوم
                          if (_predictions!.predictions.length > 1)
                            _buildSecondaryPrediction(_predictions!.predictions[1]),
                          const SizedBox(height: 8),

                          // تشخیص سوم
                          if (_predictions!.predictions.length > 2)
                            _buildSecondaryPrediction(_predictions!.predictions[2]),
                          const SizedBox(height: 20),
                        ],

                        // کادر راهنما
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade300, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.amber.shade700, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('💡 نکته مهم:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'برای تشخیص دقیق‌تر، از حشره با کیفیت بالا و نور مناسب عکس بگیرید. حشره باید واضح و در مرکز تصویر باشد.',
                                      style: TextStyle(fontSize: 13, color: Colors.amber.shade800, height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ فوتر: توسعه دهنده
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: const Text(
                  'توسعه دهنده: تورج مختارپور',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ ویجت جزئیات تشخیص اول
  Widget _buildDetailRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ ویجت تشخیص دوم و سوم
  Widget _buildSecondaryPrediction(ClassificationResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: result.rank == 2 ? Colors.blue.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '${result.rank}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: result.rank == 2 ? Colors.blue.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.pestInfo.commonName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  result.pestInfo.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: result.rank == 2 ? Colors.blue.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: result.rank == 2 ? Colors.blue.shade200 : Colors.orange.shade200,
              ),
            ),
            child: Text(
              '${(result.confidence * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: result.rank == 2 ? Colors.blue.shade700 : Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
