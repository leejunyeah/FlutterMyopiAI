import 'package:flustars/flustars.dart';

// key for sph
const KEY_GL_SPH_LEFT = 'key_gl_sph_l';
const KEY_GL_SPH_RIGHT = 'key_gl_sph_r';
// key for cyl
const KEY_GL_CYL_LEFT = 'key_gl_cyl_l';
const KEY_GL_CYL_RIGHT = 'key_gl_cyl_r';
// key for ax
const KEY_GL_AX_LEFT = 'key_gl_ax_l';
const KEY_GL_AX_RIGHT = 'key_gl_ax_r';
// key for add
const KEY_GL_ADD_LEFT = 'key_gl_add_l';
const KEY_GL_ADD_RIGHT = 'key_gl_add_r';
// key for pd
const KEY_GL_PD = 'key_gl_pd';
// key for result
const KEY_MYOPIA_RESULT = 'key_myopia_result';
// key for create time
const KEY_CREATE_TIME = 'key_create_time';

const KEY_202020 = 'key_202020';
const KEY_FIRST_START = 'key_first_start';

const LEVEL_NONE = 0;
const LEVEL_NORMAL = 1;
const LEVEL_MILD = 2;
const LEVEL_MODERATE = 3;
const LEVEL_HIGH = 4;

const MIN = 0.00;
const NORMAL_MAX = -0.50;
const MILD_MAX = -3.00;
const MODERATE_MAX = -6.00;

double glSphLeft = 0.0;
double glSphRight = 0.0;
double glCylLeft = 0.0;
double glCylRight = 0.0;
int glAxLeft = 0;
int glAxRight = 0;
double glAddLeft = 0.0;
double glAddRight = 0.0;
int glPd = 0;

int glResult = LEVEL_NONE;
String glCreateTime = '';

bool gl202020 = true;

bool glFirstStart = true;

class GlobalData {
  factory GlobalData.getInstance() => _sharedInstance();

  static GlobalData _instance = GlobalData._();

  GlobalData._();

  // 静态、同步、私有访问点
  static GlobalData _sharedInstance() {
    return _instance;
  }

  void cacheCreateTime() {
    DateTime now = new DateTime.now();
    glCreateTime = now.toString();
  }

  void cacheFinalResult() {
    if (glSphLeft == null || glSphRight == null) {
      glResult = LEVEL_NORMAL;
      return;
    }

    final leftResult = glSphLeft + 0.5 * glCylLeft;
    final rightResult = glSphRight + 0.5 * glCylRight;

    final minResult = leftResult < rightResult ? leftResult : rightResult;
    final finalCheck = minResult > 0 ? 0 : minResult;

    if (finalCheck <= MODERATE_MAX) {
      // HIGH
      glResult = LEVEL_HIGH;
    } else if (finalCheck <= MILD_MAX) {
      // MODERATE
      glResult = LEVEL_MODERATE;
    } else if (finalCheck <= NORMAL_MAX) {
      // MILD
      glResult = LEVEL_MILD;
    } else {
      // NORMAL
      glResult = LEVEL_NORMAL;
    }
  }

  Future loadAsync() async {
    await SpUtil.getInstance();
    return Future.value(null);
  }

  void save202020(bool checked) {
    gl202020 = checked;
    SpUtil.putBool(KEY_202020, checked);
  }

  void saveFirstStart() {
    glFirstStart = false;
    SpUtil.putBool(KEY_FIRST_START, glFirstStart);
  }

  void saveVisionAllData() {
    SpUtil.putDouble(KEY_GL_SPH_LEFT, glSphLeft);
    SpUtil.putDouble(KEY_GL_SPH_RIGHT, glSphRight);

    SpUtil.putDouble(KEY_GL_CYL_LEFT, glCylLeft);
    SpUtil.putDouble(KEY_GL_CYL_RIGHT, glCylRight);

    SpUtil.putInt(KEY_GL_AX_LEFT, glAxLeft);
    SpUtil.putInt(KEY_GL_AX_RIGHT, glAxRight);

    SpUtil.putDouble(KEY_GL_ADD_LEFT, glAddLeft);
    SpUtil.putDouble(KEY_GL_ADD_RIGHT, glAddRight);

    SpUtil.putInt(KEY_GL_PD, glPd);

    SpUtil.putInt(KEY_MYOPIA_RESULT, glResult);

    SpUtil.putString(KEY_CREATE_TIME, glCreateTime);
  }

//  Future initOnStart() async {
//    loadAsync().then((_) => _initAllVisionData());
////    _initAllVisionData();
//    return Future.value(null);
//  }

  initAllVisionData() {
    glFirstStart = SpUtil.getBool(KEY_FIRST_START, defValue: true);

    glSphLeft = SpUtil.getDouble(KEY_GL_SPH_LEFT);
    glSphRight = SpUtil.getDouble(KEY_GL_SPH_RIGHT);

    glCylLeft = SpUtil.getDouble(KEY_GL_CYL_LEFT);
    glCylRight = SpUtil.getDouble(KEY_GL_CYL_RIGHT);

    glAxLeft = SpUtil.getInt(KEY_GL_AX_LEFT);
    glAxRight = SpUtil.getInt(KEY_GL_AX_RIGHT);

    glAddLeft = SpUtil.getDouble(KEY_GL_ADD_LEFT);
    glAddRight = SpUtil.getDouble(KEY_GL_ADD_RIGHT);

    glPd = SpUtil.getInt(KEY_GL_PD);

    glResult = SpUtil.getInt(KEY_MYOPIA_RESULT);

    glCreateTime = SpUtil.getString(KEY_CREATE_TIME);

    gl202020 = SpUtil.getBool(KEY_202020, defValue: true);

  }
}
