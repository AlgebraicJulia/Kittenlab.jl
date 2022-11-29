package kibm
import cats.effect._, org.http4s._, org.http4s.dsl.io._
import org.http4s.ember.server._
import org.http4s.implicits._
import org.http4s.server.Router
import scala.concurrent.duration._
import com.comcast.ip4s._
import cats.effect.std.AtomicCell


object Main extends IOApp {
  type State = AtomicCell[IO, Map[String, Int]]

  extension (s: Map[String, Int]) {
    def increment(k: String) = {
      val v = s.getOrElse(k, 0) + 1
      (s + (k -> v), v)
    }
  }

  def counterService(state: State) = HttpRoutes.of[IO] {
    case POST -> Root / "increment" / section =>
      Ok(state.modify(_.increment(section)).map(v => s"set value for ${section} to ${v}"))
    case GET -> Root / "get" =>
      Ok(state.get.map(_.toString))
  }

  def httpApp(state: State) = Router("/" -> counterService(state)).orNotFound

  def server(state: State) = EmberServerBuilder
    .default[IO]
    .withHost(ipv4"0.0.0.0")
    .withPort(port"8765")
    .withHttpApp(httpApp(state))
    .build

  def run(args: List[String]): IO[ExitCode] =
    for {
      state <- AtomicCell[IO].of(Map[String, Int]())
      _ <- server(state).use(_ => IO.never)
    } yield ExitCode.Success
}
