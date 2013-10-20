import java.io._
import scala.io._

def ls4(dir: String) = {
  def ls(dir: String) : Seq[File] = {
    new File(dir).listFiles.flatMap {
      case f if f.isDirectory => ls(f.getPath)
      case x => List(x)
    }
  }
  ls(dir).filter(_.getPath.endsWith(".coffee")).map(f => (f,Source.fromFile(f)))
}

val sources = ls4("./")
for((fname, source) <- sources) {
    //val reg = """namespace 'octagram', -> class *([a-zA-Z]+)( extends [a-zA-Z]+)?""".r
    val reg = """class *([a-zA-Z]+)( extends [a-zA-Z]+)?""".r
    val lines = source.getLines
    val classNames = lines.map(line => {
      line match {
        case reg(className, superName) => className.trim
        case l => 
      }
    }).filter(_!=())
    val exports = classNames.map(c=> "octagram." + c + " = " +  c)
    val writer = new FileWriter(fname, true)
    val bw = new BufferedWriter(writer)
    val out = new PrintWriter(bw, true)
    out.println()
    exports.foreach(e => {
      out.println(e)
    })
}
