import mill._
import mill.scalalib._

object kibm extends ScalaModule {

  val http4sVersion = "0.23.16"

  def scalaVersion = "3.2.1"

  def ivyDeps = Agg(
    ivy"org.http4s::http4s-ember-server::${http4sVersion}",
    ivy"org.http4s::http4s-ember-client::${http4sVersion}",
    ivy"org.http4s::http4s-dsl::${http4sVersion}",
    ivy"org.typelevel::cats-effect::3.4.1",
  )

  object test extends Tests with TestModule.Munit {
    def ivyDeps = Agg(
      ivy"org.scalameta::munit::0.7.29"
    )
  }
}

