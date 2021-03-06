{-# LANGUAGE CPP #-}
import Test.Framework (defaultMain, testGroup, Test)
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2
import Test.HUnit hiding (Test)

import Data.Word
import Data.OpenPGP.Arbitrary ()
import qualified Data.OpenPGP as OpenPGP
import qualified Data.OpenPGP.Internal as OpenPGP

#ifdef CEREAL
import Data.Serialize
import qualified Data.ByteString as B

decode' :: (Serialize a) => B.ByteString -> a
decode' x = let Right v = decode x in v
#else
import Data.Binary
import qualified Data.ByteString.Lazy as B

decode' :: (Binary a) => B.ByteString -> a
decode' = decode
#endif

testSerialization :: FilePath -> Assertion
testSerialization fp = do
	bs <- B.readFile $ "tests/data/" ++ fp
	nullShield "First" (decode' bs) (\firstpass ->
			nullShield "Second" (decode' $ encode firstpass) (
				assertEqual ("for " ++ fp) firstpass
			)
		)
	where
	nullShield pass (OpenPGP.Message []) _ =
		assertFailure $ pass ++ " pass of " ++ fp ++ " decoded to nothing."
	nullShield _ m f = f m

prop_s2k_count :: Word8 -> Bool
prop_s2k_count c =
	c == OpenPGP.encode_s2k_count (OpenPGP.decode_s2k_count c)

prop_MPI_serialization_loop :: OpenPGP.MPI -> Bool
prop_MPI_serialization_loop mpi =
	mpi == decode' (encode mpi)

prop_S2K_serialization_loop :: OpenPGP.S2K -> Bool
prop_S2K_serialization_loop s2k =
	s2k == decode' (encode s2k)

prop_SignatureSubpacket_serialization_loop :: OpenPGP.SignatureSubpacket -> Bool
prop_SignatureSubpacket_serialization_loop packet =
	packet == decode' (encode packet)

tests :: [Test]
tests =
	[
		testGroup "Serialization" [
			testCase "000001-006.public_key" (testSerialization "000001-006.public_key"),
			testCase "000002-013.user_id" (testSerialization "000002-013.user_id"),
			testCase "000003-002.sig" (testSerialization "000003-002.sig"),
			testCase "000004-012.ring_trust" (testSerialization "000004-012.ring_trust"),
			testCase "000005-002.sig" (testSerialization "000005-002.sig"),
			testCase "000006-012.ring_trust" (testSerialization "000006-012.ring_trust"),
			testCase "000007-002.sig" (testSerialization "000007-002.sig"),
			testCase "000008-012.ring_trust" (testSerialization "000008-012.ring_trust"),
			testCase "000009-002.sig" (testSerialization "000009-002.sig"),
			testCase "000010-012.ring_trust" (testSerialization "000010-012.ring_trust"),
			testCase "000011-002.sig" (testSerialization "000011-002.sig"),
			testCase "000012-012.ring_trust" (testSerialization "000012-012.ring_trust"),
			testCase "000013-014.public_subkey" (testSerialization "000013-014.public_subkey"),
			testCase "000014-002.sig" (testSerialization "000014-002.sig"),
			testCase "000015-012.ring_trust" (testSerialization "000015-012.ring_trust"),
			testCase "000016-006.public_key" (testSerialization "000016-006.public_key"),
			testCase "000017-002.sig" (testSerialization "000017-002.sig"),
			testCase "000018-012.ring_trust" (testSerialization "000018-012.ring_trust"),
			testCase "000019-013.user_id" (testSerialization "000019-013.user_id"),
			testCase "000020-002.sig" (testSerialization "000020-002.sig"),
			testCase "000021-012.ring_trust" (testSerialization "000021-012.ring_trust"),
			testCase "000022-002.sig" (testSerialization "000022-002.sig"),
			testCase "000023-012.ring_trust" (testSerialization "000023-012.ring_trust"),
			testCase "000024-014.public_subkey" (testSerialization "000024-014.public_subkey"),
			testCase "000025-002.sig" (testSerialization "000025-002.sig"),
			testCase "000026-012.ring_trust" (testSerialization "000026-012.ring_trust"),
			testCase "000027-006.public_key" (testSerialization "000027-006.public_key"),
			testCase "000028-002.sig" (testSerialization "000028-002.sig"),
			testCase "000029-012.ring_trust" (testSerialization "000029-012.ring_trust"),
			testCase "000030-013.user_id" (testSerialization "000030-013.user_id"),
			testCase "000031-002.sig" (testSerialization "000031-002.sig"),
			testCase "000032-012.ring_trust" (testSerialization "000032-012.ring_trust"),
			testCase "000033-002.sig" (testSerialization "000033-002.sig"),
			testCase "000034-012.ring_trust" (testSerialization "000034-012.ring_trust"),
			testCase "000035-006.public_key" (testSerialization "000035-006.public_key"),
			testCase "000036-013.user_id" (testSerialization "000036-013.user_id"),
			testCase "000037-002.sig" (testSerialization "000037-002.sig"),
			testCase "000038-012.ring_trust" (testSerialization "000038-012.ring_trust"),
			testCase "000039-002.sig" (testSerialization "000039-002.sig"),
			testCase "000040-012.ring_trust" (testSerialization "000040-012.ring_trust"),
			testCase "000041-017.attribute" (testSerialization "000041-017.attribute"),
			testCase "000042-002.sig" (testSerialization "000042-002.sig"),
			testCase "000043-012.ring_trust" (testSerialization "000043-012.ring_trust"),
			testCase "000044-014.public_subkey" (testSerialization "000044-014.public_subkey"),
			testCase "000045-002.sig" (testSerialization "000045-002.sig"),
			testCase "000046-012.ring_trust" (testSerialization "000046-012.ring_trust"),
			testCase "000047-005.secret_key" (testSerialization "000047-005.secret_key"),
			testCase "000048-013.user_id" (testSerialization "000048-013.user_id"),
			testCase "000049-002.sig" (testSerialization "000049-002.sig"),
			testCase "000050-012.ring_trust" (testSerialization "000050-012.ring_trust"),
			testCase "000051-007.secret_subkey" (testSerialization "000051-007.secret_subkey"),
			testCase "000052-002.sig" (testSerialization "000052-002.sig"),
			testCase "000053-012.ring_trust" (testSerialization "000053-012.ring_trust"),
			testCase "000054-005.secret_key" (testSerialization "000054-005.secret_key"),
			testCase "000055-002.sig" (testSerialization "000055-002.sig"),
			testCase "000056-012.ring_trust" (testSerialization "000056-012.ring_trust"),
			testCase "000057-013.user_id" (testSerialization "000057-013.user_id"),
			testCase "000058-002.sig" (testSerialization "000058-002.sig"),
			testCase "000059-012.ring_trust" (testSerialization "000059-012.ring_trust"),
			testCase "000060-007.secret_subkey" (testSerialization "000060-007.secret_subkey"),
			testCase "000061-002.sig" (testSerialization "000061-002.sig"),
			testCase "000062-012.ring_trust" (testSerialization "000062-012.ring_trust"),
			testCase "000063-005.secret_key" (testSerialization "000063-005.secret_key"),
			testCase "000064-002.sig" (testSerialization "000064-002.sig"),
			testCase "000065-012.ring_trust" (testSerialization "000065-012.ring_trust"),
			testCase "000066-013.user_id" (testSerialization "000066-013.user_id"),
			testCase "000067-002.sig" (testSerialization "000067-002.sig"),
			testCase "000068-012.ring_trust" (testSerialization "000068-012.ring_trust"),
			testCase "000069-005.secret_key" (testSerialization "000069-005.secret_key"),
			testCase "000070-013.user_id" (testSerialization "000070-013.user_id"),
			testCase "000071-002.sig" (testSerialization "000071-002.sig"),
			testCase "000072-012.ring_trust" (testSerialization "000072-012.ring_trust"),
			testCase "000073-017.attribute" (testSerialization "000073-017.attribute"),
			testCase "000074-002.sig" (testSerialization "000074-002.sig"),
			testCase "000075-012.ring_trust" (testSerialization "000075-012.ring_trust"),
			testCase "000076-007.secret_subkey" (testSerialization "000076-007.secret_subkey"),
			testCase "000077-002.sig" (testSerialization "000077-002.sig"),
			testCase "000078-012.ring_trust" (testSerialization "000078-012.ring_trust"),
			testCase "002182-002.sig" (testSerialization "002182-002.sig"),
			testCase "pubring.gpg" (testSerialization "pubring.gpg"),
			testCase "secring.gpg" (testSerialization "secring.gpg"),
			testCase "compressedsig.gpg" (testSerialization "compressedsig.gpg"),
			testCase "compressedsig-zlib.gpg" (testSerialization "compressedsig-zlib.gpg"),
			testCase "compressedsig-bzip2.gpg" (testSerialization "compressedsig-bzip2.gpg"),
			testCase "onepass_sig" (testSerialization "onepass_sig"),
			testCase "symmetrically_encrypted" (testSerialization "symmetrically_encrypted"),
			testCase "uncompressed-ops-dsa.gpg" (testSerialization "uncompressed-ops-dsa.gpg"),
			testCase "uncompressed-ops-dsa-sha384.txt.gpg" (testSerialization "uncompressed-ops-dsa-sha384.txt.gpg"),
			testCase "uncompressed-ops-rsa.gpg" (testSerialization "uncompressed-ops-rsa.gpg"),
			testCase "3F5BBA0B0694BEB6000005-002.sig" (testSerialization "3F5BBA0B0694BEB6000005-002.sig"),
			testCase "3F5BBA0B0694BEB6000017-002.sig" (testSerialization "3F5BBA0B0694BEB6000017-002.sig"),
			testProperty "MPI encode/decode" prop_MPI_serialization_loop,
			testProperty "S2K encode/decode" prop_S2K_serialization_loop,
			testProperty "SignatureSubpacket encode/decode" prop_SignatureSubpacket_serialization_loop
		],
		testGroup "S2K count" [
			testProperty "S2K count encode reverses decode" prop_s2k_count
		]
	]

main :: IO ()
main = defaultMain tests
